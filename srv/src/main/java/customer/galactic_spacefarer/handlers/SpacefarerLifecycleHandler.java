package customer.galactic_spacefarer.handlers;

import java.math.BigDecimal;
import java.text.MessageFormat;
import java.util.Locale;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.sap.cds.services.ErrorStatuses;
import com.sap.cds.services.ServiceException;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.cds.CqnService;

import cds.gen.Spacefarers;

import customer.galactic_spacefarer.notification.SpacefarerNotificationService;

@Component
@ServiceName("GalacticSpacefarerService")
public class SpacefarerLifecycleHandler implements EventHandler {

    private static final Logger logger = LoggerFactory.getLogger(SpacefarerLifecycleHandler.class);

    private static final BigDecimal MIN_STARDUST = BigDecimal.ZERO;
    private static final BigDecimal MAX_STARDUST = new BigDecimal("1000000");
    private static final int MIN_NAVIGATION_SKILL = 0;
    private static final int MAX_NAVIGATION_SKILL = 100;
    private static final Pattern EMAIL_PATTERN = Pattern
            .compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", Pattern.CASE_INSENSITIVE);

    private final SpacefarerNotificationService notificationService;

    public SpacefarerLifecycleHandler(SpacefarerNotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @Before(event = CqnService.EVENT_CREATE, entity = "Spacefarers")
    public void beforeCreateSpacefarers(Spacefarers spacefarer) {
        prepareForAdventure(spacefarer);
    }

    private void prepareForAdventure(Spacefarers spacefarer) {
        BigDecimal stardust = spacefarer.getStardustCollection();
        if (stardust == null) {
            stardust = MIN_STARDUST;
        }
        if (stardust.compareTo(MIN_STARDUST) < 0) {
            logger.warn("Stardust collection below cosmic minimum for {}. Resetting to {}.",
                    resolveDisplayName(spacefarer), MIN_STARDUST);
            stardust = MIN_STARDUST;
        }
        if (stardust.compareTo(MAX_STARDUST) > 0) {
            logger.warn("Stardust collection above safe threshold for {}. Capping at {}.",
                    resolveDisplayName(spacefarer), MAX_STARDUST);
            stardust = MAX_STARDUST;
        }
        spacefarer.setStardustCollection(stardust);

        Integer navigationSkill = spacefarer.getWormholeNavigationSkill();
        if (navigationSkill == null) {
            navigationSkill = MIN_NAVIGATION_SKILL;
        }
        if (navigationSkill < MIN_NAVIGATION_SKILL) {
            logger.warn("Wormhole navigation skill below cosmic minimum for {}. Resetting to {}.",
                    resolveDisplayName(spacefarer), MIN_NAVIGATION_SKILL);
            navigationSkill = MIN_NAVIGATION_SKILL;
        }
        if (navigationSkill > MAX_NAVIGATION_SKILL) {
            logger.warn("Wormhole navigation skill above cosmic threshold for {}. Capping at {}.",
                    resolveDisplayName(spacefarer), MAX_NAVIGATION_SKILL);
            navigationSkill = MAX_NAVIGATION_SKILL;
        }
        spacefarer.setWormholeNavigationSkill(navigationSkill);

        validateContactEmail(spacefarer);
    }

    @After(event = CqnService.EVENT_CREATE, entity = "Spacefarers")
    public void afterCreateSpacefarers(Spacefarers spacefarer) {
        String displayName = resolveDisplayName(spacefarer);
        notificationService.sendWelcomeEmail(spacefarer, displayName);
        logger.info("\uD83D\uDE80 Cosmic notification recorded for {}. Stardust={} WormholeNavigationSkill={}.",
                displayName, spacefarer.getStardustCollection(), spacefarer.getWormholeNavigationSkill());
    }

    private String resolveDisplayName(Spacefarers spacefarer) {
        String callSign = safeTrim(spacefarer.getCallSign());
        if (!callSign.isEmpty()) {
            return callSign;
        }

        String firstName = safeTrim(spacefarer.getFirstName());
        String lastName = safeTrim(spacefarer.getLastName());
        String fullName = (firstName + " " + lastName).trim();
        return fullName.isEmpty() ? "Spacefarer Cadet" : fullName;
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private void validateContactEmail(Spacefarers spacefarer) {
        String contactEmail = safeTrim(spacefarer.getContactEmail());
        if (contactEmail.isEmpty()) {
            spacefarer.setContactEmail(null);
            return;
        }

        if (!EMAIL_PATTERN.matcher(contactEmail).matches()) {
            String message = MessageFormat.format("The contact email ''{0}'' is not valid for {1}.", contactEmail,
                    resolveDisplayName(spacefarer));
            throw new ServiceException(ErrorStatuses.BAD_REQUEST, message);
        }

        spacefarer.setContactEmail(contactEmail.toLowerCase(Locale.ROOT));
    }
}