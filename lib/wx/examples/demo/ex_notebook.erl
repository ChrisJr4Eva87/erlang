%%
%% %CopyrightBegin%
%% 
%% Copyright Ericsson AB 2009. All Rights Reserved.
%% 
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%% 
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%% 
%% %CopyrightEnd%

-module(ex_notebook).

-include_lib("wx/include/wx.hrl").

-behavoiur(wx_object).

-export([start/1, init/1, terminate/2,  code_change/3,
	 handle_info/2, handle_call/3, handle_event/2]).

-record(state, 
	{
	  parent,
	  config,
	  notebook
	 }).

start(Config) ->
    wx_object:start_link(?MODULE, Config, []).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init(Config) ->
        wx:batch(fun() -> do_init(Config) end).
do_init(Config) ->
    Parent = proplists:get_value(parent, Config),  
    Panel = wxPanel:new(Parent, []),
    %% Setup sizers
    MainSizer = wxStaticBoxSizer:new(?wxVERTICAL, Panel, 
				     [{label, "wxNotebook"}]),

    Notebook = wxNotebook:new(Panel, 1, [{style, ?wxBK_DEFAULT%,
					        %?wxBK_ALIGN_MASK,
					        %?wxBK_TOP,
					        %?wxBK_BOTTOM,
					        %?wxBK_LEFT,
					        %?wxBK_RIGHT,
					        %?wxNB_MULTILINE % windows only
					 }]),

    %% Make a wxImageList to be able to display icons in the tab field
    IL = wxImageList:new(16,16),
    wxImageList:add(IL, wxArtProvider:getBitmap("wxART_INFORMATION", [{size, {16,16}}])),
    wxNotebook:assignImageList(Notebook, IL),
    


    Win1 = wxPanel:new(Notebook, []),
    wxPanel:setBackgroundColour(Win1, ?wxRED),
    Win1Text = wxStaticText:new(Win1, ?wxID_ANY, "This is a red tab.",
				[{pos, {50, 100}}]),
    wxStaticText:setForegroundColour(Win1Text, ?wxGREEN),
    Sizer1 = wxBoxSizer:new(?wxHORIZONTAL),
    wxSizer:add(Sizer1, Win1Text),
    wxPanel:setSizer(Win1, Sizer1),
    wxNotebook:addPage(Notebook, Win1, "Red", []),

    Win2 = wxPanel:new(Notebook, []),
    wxPanel:setBackgroundColour(Win2, ?wxBLUE),
    Win2Text = wxStaticText:new(Win2, ?wxID_ANY, "This is a blue tab.",
				[{pos, {50, 100}}]),
    wxStaticText:setForegroundColour(Win2Text, {255,255,0,255}),
    Sizer2 = wxBoxSizer:new(?wxHORIZONTAL),
    wxSizer:add(Sizer2, Win2Text),
    wxPanel:setSizer(Win2, Sizer2),
    wxNotebook:addPage(Notebook, Win2, "Blue", []),

    Win3 = wxPanel:new(Notebook, []),
    wxNotebook:addPage(Notebook, Win3, "No color", []),

    Win4 = wxPanel:new(Notebook, []),
    wxPanel:setBackgroundColour(Win4, ?wxBLACK),
    Win4Text = wxStaticText:new(Win4, ?wxID_ANY, "This is a black tab.",
				[{pos, {50, 100}}]),
    wxStaticText:setForegroundColour(Win4Text, ?wxWHITE),
    Sizer4 = wxBoxSizer:new(?wxHORIZONTAL),
    wxSizer:add(Sizer4, Win4Text),
    wxPanel:setSizer(Win4, Sizer4),
    wxNotebook:addPage(Notebook, Win4, "Black", []),

    Win5 = wxPanel:new(Notebook, []),
    wxNotebook:addPage(Notebook, Win5, "Tab with icon", []),
    wxNotebook:setPageImage(Notebook, 4, 0),
    



    %% Add to sizers
    wxSizer:add(MainSizer, Notebook, [{proportion, 1},
				  {flag, ?wxEXPAND}]),

    wxNotebook:connect(Notebook, command_notebook_page_changed,
		       [{skip, true}]), % {skip, true} has to be set on windows
    wxPanel:setSizer(Panel, MainSizer),
    {Panel, #state{parent=Panel, config=Config,
		   notebook = Notebook}}.


%%%%%%%%%%%%
%% Callbacks handled as normal gen_server callbacks
handle_info(Msg, State) ->
    demo:format(State#state.config, "Got Info ~p\n",[Msg]),
    {noreply,State}.

handle_call(Msg, _From, State) ->
    demo:format(State#state.config,"Got Call ~p\n",[Msg]),
    {reply,ok,State}.

%% Async Events are handled in handle_event as in handle_info
handle_event(#wx{event = #wxNotebook{type = command_notebook_page_changed}},
	     State = #state{notebook = Notebook}) ->
    Selection = wxNotebook:getSelection(Notebook),
    Title = wxNotebook:getPageText(Notebook, Selection),
    demo:format(State#state.config,"You have selected the tab ~p\n",[Title]),
    {noreply,State};
handle_event(Ev = #wx{}, State = #state{}) ->
    demo:format(State#state.config,"Got Event ~p\n",[Ev]),
    {noreply,State}.

code_change(_, _, State) ->
    {stop, ignore, State}.

terminate(_Reason, _State) ->
    ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Local functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	    
    
