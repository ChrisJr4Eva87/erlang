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

%% This is example of the widgets and usage of wxErlang
%% Hopefully it will contain all implemented widgets, it's event handling
%% and some tutorials of how to use sizers and other stuff.

-module(ex_button).

-include_lib("wx/include/wx.hrl").

-behavoiur(wx_object).
-export([start/1, init/1, terminate/2,  code_change/3,
	 handle_info/2, handle_call/3, handle_event/2]).

-record(state, 
	{
	  parent,
	  config
	 }).

start(Config) ->
    wx_object:start_link(?MODULE, Config, []).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init(Config) ->
        wx:batch(fun() -> do_init(Config) end).
do_init(Config) ->
    Parent = proplists:get_value(parent, Config),  
    Panel = wxScrolledWindow:new(Parent),

    %% Setup sizers
    Sz = wxBoxSizer:new(?wxVERTICAL),

    SzFlags = [{proportion, 0}, {border, 4}, {flag, ?wxALL}],
    Expand  = [{proportion, 0}, {border, 4}, {flag, ?wxALL bor ?wxEXPAND}],

    ButtSz = wxStaticBoxSizer:new(?wxHORIZONTAL, Panel, 
				  [{label, "wxButton"}]),

    B10 = wxButton:new(Panel, 10, [{label,"Normal"}]),
    wxButton:setToolTip(B10, "Normal button with (default) centered label"),

    B11 = wxToggleButton:new(Panel, 11, "Toggle Button"),
    wxToggleButton:connect(B11, command_togglebutton_clicked),
    wxButton:setToolTip(B11, "A toggle button"),

    B12 = wxButton:new(Panel, 12, [{label,"Default"}]),
    wxButton:setDefault(B12),
    wxButton:setToolTip(B12, "Normal button set to be the default button"),

    B13 = wxButton:new(Panel, 13, [{label,"Disabled"}]),
    wxButton:disable(B13),
    wxButton:setToolTip(B13, "Disabled Normal button"),
    
    B14 = wxBitmapButton:new(Panel, 14, create_bitmap("A bitmap button")),
    wxButton:setToolTip(B14, "A Bitmap button"),
    [wxSizer:add(ButtSz, Button, SzFlags) || Button <- [B10, B11, B12, B13, B14]],
    
    %% Alignment and NO_BORDER only works on Win and GTK according to docs.
    AlignSz = wxStaticBoxSizer:new(?wxHORIZONTAL, Panel, 
				   [{label, "Alignment Style"}]),

    B20 = wxButton:new(Panel, 20, [{label,"Left Aligned"}, {size, {100, -1}}, 
				 {style,?wxBU_LEFT}]),
    wxButton:setToolTip(B20, "Normal button with left aligned label"),
    
    B21 = wxButton:new(Panel, 21, [{label,"Top Aligned"},  {size, {-1, 50}},
				 {style,?wxBU_TOP}]),
    wxButton:setToolTip(B21, "Normal button with top aligned label"),

    B22 = wxButton:new(Panel, 22, [{label,"Lower Right Aligned"},  {size, {150, 50}},
				 {style,?wxBU_BOTTOM bor ?wxBU_RIGHT}]),
    wxButton:setToolTip(B22, "Normal button with top right aligned label"),
    [wxSizer:add(AlignSz, Button, SzFlags) || Button <- [B20,B21,B22]],

    %% Other types
    OtherSz = wxStaticBoxSizer:new(?wxHORIZONTAL, Panel, 
				   [{label, "Other Styles"}]),

    B30 = wxButton:new(Panel, 30, [{label,"Flat Style"}, {style, ?wxNO_BORDER}]),
    wxButton:setToolTip(B30, "Flat style button, on some OS'es"),
    
    B31 = wxButton:new(Panel, 31, [{label,"Exact Fit"}, {style, ?wxBU_EXACTFIT}]),
    wxButton:setToolTip(B31, "Minimal Size button"),

    [wxSizer:add(OtherSz, Button, SzFlags) || Button <- [B30,B31]],

    %% Stock Buttons
    StockTopSz = wxStaticBoxSizer:new(?wxHORIZONTAL, Panel, 
				      [{label, "Stock Buttons"}]),

    StockButts = [wxButton:new(Panel, Id) || Id <- stock_buttons()],        
    StockSz = wxGridSizer:new(0,5,3,3),
    [wxSizer:add(StockSz, Butt, SzFlags) || Butt <- StockButts],
    wxSizer:add(StockTopSz, StockSz, SzFlags),
    
    %% Add to Main sizer
    [wxSizer:add(Sz, Button, Flag) || 
	{Button, Flag} <- [{ButtSz,SzFlags},{AlignSz,Expand},
			   {OtherSz,Expand}, {StockTopSz, Expand}]],
    
    wxWindow:connect(Panel, command_button_clicked),
    wxWindow:setSizer(Panel, Sz),
    wxSizer:layout(Sz),
    wxScrolledWindow:setScrollRate(Panel, 5, 5),
    {Panel, #state{parent=Panel, config=Config}}.

stock_buttons() ->
    [?wxID_ABOUT,
     ?wxID_ADD,
     ?wxID_APPLY,
     ?wxID_BOLD,
     ?wxID_CANCEL,
     ?wxID_CLEAR,
     ?wxID_CLOSE,
     ?wxID_COPY,
     ?wxID_CUT,
     ?wxID_DELETE,
     ?wxID_EDIT,
     ?wxID_FIND,
     ?wxID_FILE,
     ?wxID_REPLACE,
     ?wxID_BACKWARD,
     ?wxID_DOWN,
     ?wxID_FORWARD,
     ?wxID_UP,
     ?wxID_HELP,
     ?wxID_HOME,
     ?wxID_INDENT,
     ?wxID_INDEX,
     ?wxID_ITALIC,
     ?wxID_JUSTIFY_CENTER,
     ?wxID_JUSTIFY_FILL,
     ?wxID_JUSTIFY_LEFT,
     ?wxID_JUSTIFY_RIGHT,
     ?wxID_NEW,
     ?wxID_NO,
     ?wxID_OK,
     ?wxID_OPEN,
     ?wxID_PASTE,
     ?wxID_PREFERENCES,
     ?wxID_PRINT,
     ?wxID_PREVIEW,
     ?wxID_PROPERTIES,
     ?wxID_EXIT,
     ?wxID_REDO,
     ?wxID_REFRESH,
     ?wxID_REMOVE,
     ?wxID_REVERT_TO_SAVED,
     ?wxID_SAVE,
     ?wxID_SAVEAS,
     ?wxID_SELECTALL,
     ?wxID_STOP,
     ?wxID_UNDELETE,
     ?wxID_UNDERLINE,
     ?wxID_UNDO,
     ?wxID_UNINDENT,
     ?wxID_YES,
     ?wxID_ZOOM_100,
     ?wxID_ZOOM_FIT,
     ?wxID_ZOOM_IN,
     ?wxID_ZOOM_OUT].


%%%%%%%%%%%%
%% Async Events are handled in handle_event as in handle_info
handle_event(#wx{id=Id, event=#wxCommand{type=command_button_clicked}}, 
	     State = #state{parent=Parent}) ->
    B0 = wxWindow:findWindowById(Id, [{parent, Parent}]),
    Butt = wx:typeCast(B0, wxButton),
    Label = wxButton:getLabel(Butt),
    demo:format(State#state.config,"Button: \'~ts\' clicked~n",[Label]),
    {noreply,State};

handle_event(#wx{event=#wxCommand{type=command_togglebutton_clicked}}, 
	     State = #state{}) ->
    demo:format(State#state.config,"Button: You toggled the 'Toggle button' ~n",[]),
    {noreply,State};

handle_event(Ev = #wx{}, State = #state{}) ->
    demo:format(State#state.config,"Got Event ~p~n",[Ev]),
    {noreply,State}.

%% Callbacks handled as normal gen_server callbacks
handle_info(Msg, State) ->
    demo:format(State#state.config, "Got Info ~p~n",[Msg]),
    {noreply,State}.

handle_call(Msg, _From, State) ->
    demo:format(State#state.config,"Got Call ~p~n",[Msg]),
    {reply,ok,State}.

code_change(_, _, State) ->
    {stop, ignore, State}.

terminate(_Reason, _State) ->
    ok.

%%%%%  a copy from wxwidgets samples.
create_bitmap(Label) ->
    Bmp = wxBitmap:new(140, 30),
    DC = wxMemoryDC:new(),
    wxMemoryDC:selectObject(DC,  Bmp),
    wxDC:setBackground(DC, ?wxWHITE_BRUSH),
    wxDC:clear(DC),
    wxDC:setTextForeground(DC, ?wxBLUE),
    wxDC:drawLabel(DC, Label, {5,5,130,20}, [{alignment, ?wxALIGN_CENTER}]),
    wxMemoryDC:destroy(DC),
    Bmp.

    
