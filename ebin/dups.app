%% ex: ts=4 sw=4 ft=erlang et

{application, dups, [
    {description, "Find duplicate files"},
    {vsn, "0.0.0"},
    {modules, [
        dups
    ]},
    {registered, []},
    {applications, [
        kernel, stdlib, crypto
    ]},
    {env, []}
]}.
