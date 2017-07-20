{   
    application, server,
    [   
        {description, "This is game server."},   
        {vsn, "1.0"},    
        {modules, [main]},   
        {registered, [server_sup]},   
        {applications, [kernel, stdlib, sasl]},
        {mod, {server_app, []}},
        {start_phases, []},
		{env, [
			{log_tty, true},
			{language, chinese_config},
			{ver, "1.0"},
			{is_realese, true}
			]
		}   		
    ]
}.  