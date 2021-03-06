-module(dups).

-export([
    main/1
]).

-define(BLOCK_SIZE, 128*1024).

main([_ | _]=Dirs) ->
    application:start(crypto),
    Map = lists:foldl(fun (AMap, Acc) ->
                        dict:merge(fun (_, Value1, Value2) ->
                                    Value1 ++ Value2
                                   end, Acc, AMap)
                      end,
                      dict:new(),
                      pmap(fun(Dir) ->
                            filelib:fold_files(Dir, ".*", true,
                                               fun(FileName, Dict) -> dict:append(sum(FileName), FileName, Dict) end,
                                               dict:new())
                           end, Dirs)),
    print_dups(lists:filter(fun ({_, Value}) -> length(Value) > 1 end, dict:to_list(Map)));
main([]) ->
    main(["."]).

print_dups([{_, Names} | Rest]) ->
    io:format("~b duplicates\n", [length(Names)]),
    print_names(lists:sort(Names)),
    print_dups(Rest);
print_dups([]) ->
    ok.

print_names([Name | Rest]) ->
    io:format("  ~s\n", [Name]),
    print_names(Rest);
print_names([]) ->
    ok.

sum(FileName) ->
    {ok, Device} = file:open(FileName, [read, raw, binary]),
    SHA1 = sum(Device, crypto:sha_init()),
    file:close(Device),
    SHA1.

sum(Device, SHA1) ->
    case file:read(Device, ?BLOCK_SIZE) of
        {ok, Data} ->
            sum(Device, crypto:sha_update(SHA1, Data));

        eof ->
            crypto:sha_final(SHA1)
    end.


% parallel map implementation (copied from web, TODO: check where from)
pmap(F, L) ->
    await2(spawn_jobs(F, L)).

spawn_jobs(F, L) ->
    Parent = self(),
    [spawn(fun() -> Parent ! {self(), catch {ok, F(X)}} end) || X <- L].

await2([H|T]) ->
    receive
        {H, {ok, Res}} ->
            [Res | await2(T)];

        {H, {'EXIT',_} = Err} ->
            [exit(Pid, kill) || Pid <- T],
            [receive {P, _} -> ok after 0 -> ok end || P <- T],
            erlang:error(Err)
    end;
await2([]) ->
    [].

% vim:ft=erlang
