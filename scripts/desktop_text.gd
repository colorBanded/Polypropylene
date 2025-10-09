extends Label
@export var letters_per_second: float = 25.0  
var previous_value = null
var target_text: String = ""
var full_text: String = ""
var current_char_index: int = 0
var char_timer: float = 0.0
var is_animating: bool = false
var delay_timer: float = 0.0
var delay_duration: float = 0.0
var is_delaying: bool = false
var is_reconnecting: bool = false
var reconnect_timer: float = 0.0
var reconnect_duration: float = 2.0
var reconnect_dot_count: int = 0
var reconnect_dot_timer: float = 0.0
var reconnect_position: int = -1

func _ready() -> void:
	update_text()

func _process(delta: float) -> void:
	var current_value = Global.Status
	if current_value != previous_value:
		previous_value = current_value
		update_text()
	
	if is_reconnecting:
		reconnect_timer += delta
		reconnect_dot_timer += delta
		
		if reconnect_dot_timer >= 0.5:
			reconnect_dot_timer = 0.0
			reconnect_dot_count = (reconnect_dot_count + 1) % 4
			var dots = ".".repeat(reconnect_dot_count)
			text = target_text.substr(0, reconnect_position) + "kernel: eth0: link down\nNetworkManager[1842]: <warn> connection timeout" + dots
		
		if reconnect_timer >= reconnect_duration:
			is_reconnecting = false
			is_animating = true
			reconnect_timer = 0.0
			reconnect_dot_count = 0
			current_char_index = reconnect_position
		return
	
	if is_delaying:
		delay_timer += delta
		if delay_timer >= delay_duration:
			is_delaying = false
			is_animating = true
	
	if is_animating:
		char_timer += delta
		var chars_to_add = int(char_timer * letters_per_second)
		if chars_to_add > 0:
			char_timer = 0.0
			current_char_index = min(current_char_index + chars_to_add, target_text.length())
			
			if reconnect_position != -1 and current_char_index >= reconnect_position and not is_reconnecting:
				is_animating = false
				is_reconnecting = true
				current_char_index = reconnect_position
				return
			
			text = target_text.substr(0, current_char_index)
			if current_char_index >= target_text.length():
				is_animating = false

func get_timestamp() -> String:
	var time = Time.get_datetime_dict_from_system()
	var future_year = 2070 + (time.year % 10)
	return "%s %2d %02d:%02d:%02d %d" % [
		["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][time.month - 1],
		time.day,
		time.hour,
		time.minute,
		time.second,
		future_year
	]

func get_short_timestamp() -> String:
	var time = Time.get_datetime_dict_from_system()
	return "%s %2d %02d:%02d:%02d" % [
		["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][time.month - 1],
		time.day,
		time.hour,
		time.minute,
		time.second
	]

func update_text() -> void:
	var value = Global.Status
	var ts = get_short_timestamp()
	var ts_full = get_timestamp()
	
	if value == 0:
		delay_duration = 4.0
	else:
		delay_duration = 0.0
	
	match value:
		0:
			target_text = """Linux version 8.12.0-214-generic (buildd@lcy02-amd64-042)
%s localhost kernel: [    0.000000] DMI: NCOM Systems/RM-2100, BIOS 4.7.2 03/22/2071
%s localhost systemd[1]: Starting Postfix Mail Transport Agent...
%s localhost postfix/master[2847]: daemon started -- version 5.2.1
%s localhost postfix/pickup[2849]: connecting to transport=local
%s localhost postfix/qmgr[2850]: processing queue
%s localhost postfix/local[2851]: message retrieved from queue
%s localhost postfix/local[2851]: delivered to: admin@ncom.int.nt.com

────────────────────────────────────────────────────────────
From: cmp@ncom.int.bk
To: admin@ncom.int.nt.com
Subject: Re: System initialization complete
Date: %s

You finally got this damn machine to work, well done. I hope 
it goes atleast a fair bit better than last time, theres some 
safeguards to work out. Ive been using some older media to test this.
 You don't have much to do now since we 
havent ported everything over. Whenever your ready, just link into the first one and 

%s localhost kernel: [13421.847362] eth0: transmit queue 0 timed out
%s localhost kernel: [13421.847389] segfault at ffffffff ip 00007f8c4d2a1e90 sp 00007ffd9c8e3a40 error 4 in libnetwork.so
%s localhost systemd[1]: postfix.service: Main process exited, code=killed, status=11/SEGV
%s localhost systemd[1]: postfix.service: Failed with result 'signal'.""" % [ts, ts, ts, ts, ts, ts, ts, ts_full, ts, ts, ts, ts]
			reconnect_position = target_text.find("kernel: [13421")
		1:
			target_text = """Linux version 8.12.0-214-generic (buildd@lcy02-amd64-042)
%s localhost postfix/local[2851]: message retrieved from queue
%s localhost postfix/local[2851]: delivered to: admin@ncom.int.nt.com

────────────────────────────────────────────────────────────
From: cmp@ncom.int.bk
To: admin@ncom.int.nt.com
Subject: Project status update
Date: %s

Duis aute irure dolor in reprehenderit in voluptate velit 
esse cillum dolore eu fugiat nulla pariatur. Excepteur sint 
occaecat cupidatat non proident, sunt desculpa culpa qui officia 
deserunt mollit anim id est laborum.

────────────────────────────────────────────────────────────
%s localhost postfix/local[2851]: cleanup complete
%s localhost systemd[1]: postfix.service: Succeeded.""" % [ts, ts, ts_full, ts, ts]
			reconnect_position = -1
		2:
			target_text = """Linux version 8.12.0-214-generic (buildd@lcy02-amd64-042)
%s localhost postfix/local[2851]: message retrieved from queue
%s localhost postfix/local[2851]: delivered to: admin@ncom.int.nt.com

────────────────────────────────────────────────────────────
From: cmp@ncom.int.bk
To: admin@ncom.int.nt.com
Subject: Technical documentation
Date: %s

Sed ut perspiciatis unde omnis iste natus error sit 
voluptatem accusantium doloremque laudantium. Totam rem 
aperiam, eaque ipsa quae ab tuffstone inventore veritatis et 
quasi architecto beatae vitae dicta sunt explicabo.

────────────────────────────────────────────────────────────
%s localhost postfix/local[2851]: cleanup complete
%s localhost systemd[1]: postfix.service: Succeeded.""" % [ts, ts, ts_full, ts, ts]
			reconnect_position = -1
		3:
			target_text = """Linux version 8.12.0-214-generic (buildd@lcy02-amd64-042)
%s localhost postfix/local[2851]: message retrieved from queue
%s localhost postfix/local[2851]: delivered to: admin@ncom.int.nt.com

────────────────────────────────────────────────────────────
From: cmp@ncom.int.bk
To: admin@ncom.int.nt.com
Subject: mreow :3 
Date: %s

Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut 
odit aut fugit, sed quia consequuntur magni dolores eos qui 
ratione voluptatem sequi nesciunt. goon porro quisquam est, 
qui dolorem ipsum quia dolor sit amet.

────────────────────────────────────────────────────────────
%s localhost postfix/local[2851]: cleanup complete
%s localhost systemd[1]: postfix.service: Succeeded.""" % [ts, ts, ts_full, ts, ts]
			reconnect_position = -1
		4:
			target_text = """Linux version 8.12.0-214-generic (buildd@lcy02-amd64-042)
%s localhost postfix/local[2851]: message retrieved from queue
%s localhost postfix/local[2851]: delivered to: admin@ncom.int.nt.com

────────────────────────────────────────────────────────────
From: cmp@ncom.int.bk
To: admin@ncom.int.nt.com
Subject: a cruel gabagools thesis
Date: %s

At vero eos et accusamus et iusto odio dignissimos ducimus 
qui blanditiis praesentium voluptatum deleniti atque corrupti 
quos dolores ligmicus quas molestias excepturi sint occaecati 
cupiditate non provident, similique sunt in culpa.

────────────────────────────────────────────────────────────
%s localhost postfix/local[2851]: cleanup complete
%s localhost systemd[1]: postfix.service: Succeeded.""" % [ts, ts, ts_full, ts, ts]
			reconnect_position = -1
		5:
			target_text = """Linux version 8.12.0-214-generic (buildd@lcy02-amd64-042)
%s localhost postfix/local[2851]: message retrieved from queue
%s localhost postfix/local[2851]: delivered to: admin@ncom.int.nt.com

────────────────────────────────────────────────────────────
From: cmp@ncom.int.bk
To: admin@ncom.int.nt.com
Subject: fuck at&t syntax
Date: %s

Temporibus autem quibusdam et aut officiis debitis aut rerum 
necessitatibus saepe eveniet ut et voluptates repudiandae 
sint et molestiae non recusandae. Itaque earum rerum hic 
tenetur a sapiente delectus, ut aut reiciendis voluptatibus.

────────────────────────────────────────────────────────────
%s localhost postfix/local[2851]: cleanup complete
%s localhost systemd[1]: postfix.service: Succeeded.""" % [ts, ts, ts_full, ts, ts]
			reconnect_position = -1
		_:
			target_text = """Linux version 8.12.0-214-generic (buildd@lcy02-amd64-042)
%s localhost postfix/local[2851]: message retrieval failed
%s localhost postfix/local[2851]: warning: unknown system state %s

────────────────────────────────────────────────────────────
From: cmp@ncom.int.bk
To: admin@ncom.int.nt.com
Subject: marp
Date: %s

Unknown system state detected: %s. Lorem ipsum dolor sit 
amet, consectetur adipiscing elit, sed do eiusmod tempor 
incididunt ut labore et dolore magna carta. Ut enim ad 
minim veniam, quis nostrud exercitation ullamco.

────────────────────────────────────────────────────────────
%s localhost postfix/local[2851]: cleanup complete
%s localhost systemd[1]: postfix.service: Exited with errors.""" % [ts, ts, str(value), ts_full, str(value), ts, ts]
			reconnect_position = -1
	
	text = ""
	current_char_index = 0
	char_timer = 0.0
	delay_timer = 0.0
	reconnect_timer = 0.0
	reconnect_dot_timer = 0.0
	is_reconnecting = false
	
	if delay_duration > 0:
		is_delaying = true
		is_animating = false
	else:
		is_delaying = false
		is_animating = true
