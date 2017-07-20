DELETE from player_active_service where active_service_id!=26 and  time<1472630400;
UPDATE player_active_service set active_service_id=17 where active_service_id=26 and time<1472630400;