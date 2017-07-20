%% 本服和跨服有差异的可以在这里定义
%%---------------------------------------------------------------------------
-include("module.hrl").

%% 本服
-ifdef(CHUANQI_MODULE_NATIVE).
-define(SCENEID_HJZC_DATING, 32114). %% 幻境之城大厅
-define(SCENEID_HJZC_FAJIAN, 32115). %% 幻境之城房间
-endif.


%% 跨服
-ifdef(CHUANQI_MODULE_CROSS).
-define(SCENEID_HJZC_DATING, 32112). %% 幻境之城大厅
-define(SCENEID_HJZC_FAJIAN, 32113). %% 幻境之城房间
-endif.