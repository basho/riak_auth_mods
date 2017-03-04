%% -------------------------------------------------------------------
%%
%% Copyright (c) 2013-2017 Basho Technologies, Inc.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(riak_auth_mods_app).
-behaviour(application).

-export([
    start/0,
    start/2,
    stop/1
]).

%% Not clear why this exists.
%% Nothing seems to call it, and it'd return an error if anything did because
%% the target application doesn't exist.
start() ->
    application:start(riak_core_app_mods).

start(_StartType, _StartArgs) ->
    case riak_auth_mods_sup:start_link() of
        {ok, _} = Ret ->
            riak_core:register(riak_auth_mods, [
                {auth_mod, {pam, riak_auth_mods_pam}}
            ]),
            Ret;
        Err ->
            Err
    end.

stop(_State) ->
    ok.
