package customer.galactic_spacefarer.notification;

import java.nio.charset.StandardCharsets;
import java.text.MessageFormat;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import cds.gen.Spacefarers;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Component
public class SpacefarerNotificationService {

    private static final Logger logger = LoggerFactory.getLogger(SpacefarerNotificationService.class);

    private final ObjectProvider<JavaMailSender> mailSenderProvider;
    private final String fromAddress;

    public SpacefarerNotificationService(ObjectProvider<JavaMailSender> mailSenderProvider,
            @Value("${spacefarer.notifications.from:}") String configuredFrom,
            @Value("${spring.mail.username:}") String springMailUser) {
        this.mailSenderProvider = mailSenderProvider;
        this.fromAddress = StringUtils.hasText(configuredFrom) ? configuredFrom : springMailUser;
    }

    public void sendWelcomeEmail(Spacefarers spacefarer, String displayName) {
        Optional<JavaMailSender> mailSenderOptional = Optional.ofNullable(mailSenderProvider.getIfAvailable());
        if (mailSenderOptional.isEmpty()) {
            logger.info("Mail sender bean not configured. Skipping cosmic welcome email for {}.", displayName);
            return;
        }

        String recipient = sanitize(spacefarer.getContactEmail());
        if (!StringUtils.hasText(recipient)) {
            logger.warn("No contact email stored for {}. Cosmic welcome email skipped.", displayName);
            return;
        }

        JavaMailSender mailSender = mailSenderOptional.get();
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, MimeMessageHelper.MULTIPART_MODE_NO,
                    StandardCharsets.UTF_8.name());

            if (StringUtils.hasText(fromAddress)) {
                helper.setFrom(fromAddress);
            }
            helper.setTo(recipient);
            helper.setSubject("Welcome to the Galactic Spacefarer Adventure");
            helper.setText(buildBody(spacefarer, displayName), false);

            mailSender.send(message);
            logger.info("\uD83D\uDE80 Cosmic welcome email dispatched to {} ({})", displayName, recipient);
        } catch (MailException | MessagingException exception) {
            logger.error("Failed to send cosmic welcome email to {} ({}): {}", displayName, recipient,
                    exception.getMessage(), exception);
        }
    }

    private String sanitize(String rawValue) {
        return rawValue == null ? null : rawValue.trim();
    }

    private String buildBody(Spacefarers spacefarer, String displayName) {
        String originPlanet = optionalText(spacefarer.getOriginPlanet());
        String stardust = Optional.ofNullable(spacefarer.getStardustCollection())
                .map(Object::toString)
                .orElse("0");
        String navigationSkill = Optional.ofNullable(spacefarer.getWormholeNavigationSkill())
                .map(Object::toString)
                .orElse("0");

        return MessageFormat.format(
                "Greetings {0}!\n\n" +
                        "Your registration for the Galactic Spacefarer Adventure is now complete. " +
                        "Here are the vital statistics for your cosmic journey:\n" +
                        " - Stardust collection: {1}\n" +
                        " - Wormhole navigation skill: {2}\n" +
                        (StringUtils.hasText(originPlanet) ? " - Origin planet: {3}\n" : "") +
                        "\nMay your travels among the stars be filled with luminous discoveries!\n" +
                        "\nGalactic Command Center",
                displayName,
                stardust,
                navigationSkill,
                originPlanet);
    }

    private String optionalText(String value) {
        return value == null ? "" : value.trim();
    }
}
