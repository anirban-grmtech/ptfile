
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";



INSERT INTO `doctorRecommendationsForPatients` (`uuid`, `uuidOfRecommendationMadeFor`, `recommendationDescription`, `notes`, `priority`, `isAutoRex`, `autoRecommendationsOrderId`, `recordChangedByUUID`, `recordChangedFromIPAddress`) VALUES
('897f78c6-3584-47fe-9236-2c3dd1070bdf', 'bfe041fa-073b-4223-8c69-0540ee678ff8', 'This is a test rex 1', NULL, NULL, NULL, NULL, '1', ''),
('bfe041fa-073b-4223-8c69-0540ee8721dd', 'bfe041fa-073b-4223-8c69-0540ee678ff8', 'This is a test rex 2', NULL, NULL, NULL, NULL, '1', '');
COMMIT;

