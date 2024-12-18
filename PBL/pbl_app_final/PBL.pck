GDPC                 p                                                                         X   res://.godot/exported/133200997/export-1b26f2d686700fb76b7eb580d2a7e968-player_edit.scn 06      �      J,��I�!�(Y�Y�PIn    P   res://.godot/exported/133200997/export-234ad4d8d43f2f55834435b9887da50b-main.res�      �      l�I�"��!�W�~}B�    P   res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn�      �       �s�������tH�����    `   res://.godot/exported/133200997/export-59fbf122d2f48b3420fcbc3e4894e060-rooms_presentation.res  �>      Q      R֙��J̺R@[R��    T   res://.godot/exported/133200997/export-f72dfba474b213710f83f5c350a04328-rooms.res          �      )@,9��8��� *�    ,   res://.godot/global_script_class_cache.cfg          �      O@/F�!��	M�       res://.godot/uid_cache.bin  �V      �       �Uz���m��o,sւ�       res://clues_label.gd�            -�፛������       res://global_signals.gd        �       ,�`7z2U��y�&W       res://main.tres.remap    U      a       ���(���R+6���       res://main.tscn.remap   pU      a       �J�Sw� ������    $   res://pbl_app_final/rooms.tres.remap�T      b       �`~�u�Jd��=�J       res://player_add.gd �3      =      ��C7�&w mU��       res://player_age_select.gd  5            C���c���F����       res://player_edit.tscn.remap�U      h       �������`��[aL�        res://player_remove.gd  �<      �       j���<��������       res://player_skill_select.gd�=      #      7n�K`���g�<�       res://project.binary�W      �      ���9X�?�>��mr�       res://room_name_edit.gd �B             �'3=�>��*�c       res://room_resource.gd  �B      ;      �s�d�!�51/��Vb       res://room_saver.gd  D      P      �J�_�r�D��i�       res://room_select.gdPE      �	      t�h�*�`Π����    $   res://rooms_presentation.tres.remap PV      o       Ry\H�|t��[~�r�       res://rooms_resource.gd 0B      o       ��ː2�W���s\e�       res://ui.theme  @O      �       ݝ���=�S�#�S��       res://ui_basic.themeP      �      +<L�cݨ(!>�47��p       res://ui_fancy.themeR      y      S,��i���^je�mj$P    list=Array[Dictionary]([{
"base": &"Label",
"class": &"CluesLabel",
"icon": "",
"language": &"GDScript",
"path": "res://clues_label.gd"
}, {
"base": &"Resource",
"class": &"RoomResource",
"icon": "",
"language": &"GDScript",
"path": "res://room_resource.gd"
}, {
"base": &"Node",
"class": &"RoomSaver",
"icon": "",
"language": &"GDScript",
"path": "res://room_saver.gd"
}, {
"base": &"Resource",
"class": &"RoomsResource",
"icon": "",
"language": &"GDScript",
"path": "res://rooms_resource.gd"
}])
��H��N�-�|ݻRSRC                  	   Resource            ��������   RoomsResource                                                   resource_local_to_scene    resource_name    script    name 
   steps_min 
   steps_max 	   duration    rooms       Script    res://rooms_resource.gd ��������   Script    res://room_resource.gd ��������      local://Resource_f5u7d          local://Resource_p78mq b         local://Resource_k7rcw �         local://Resource_04chr          local://Resource_bv1t3 y      	   Resource                   ,      Jungle Quest                            	   Resource                   ,   
   The Vault                         -   	   Resource                   ,      Haunted Hideaway       
                  Z   	   Resource                   ,   	   New Room                         Z   	   Resource                                                               RSRCx���class_name CluesLabel extends Label

var room_difficulty:float
var player_data:Dictionary

func _ready() -> void:
	GlobalSignals.room_difficulty_updated.connect(on_room_difficulty_updated)
	
	GlobalSignals.player_skill_updated.connect(on_player_skill_updated)
	GlobalSignals.player_age_updated.connect(on_player_age_updated)
	
	GlobalSignals.player_deleted.connect(on_player_deleted)
	update_label()
	
func on_room_difficulty_updated(new_difficulty:int) -> void:
	room_difficulty = new_difficulty / 1000.0
	update_label()

func on_player_skill_updated(instance_id:int, new_skill:int) -> void:
	if not player_data.has(instance_id):
		player_data[instance_id] = {"skill": -1, "age": -1}
	player_data[instance_id]["skill"] = new_skill
	update_label()

func on_player_age_updated(instance_id:int, new_age:int) -> void:
	if not player_data.has(instance_id):
		player_data[instance_id] = {"skill": -1, "age": -1}
	player_data[instance_id]["age"] = new_age
	update_label()

func on_player_deleted(instance_id:int) -> void:
	player_data.erase(instance_id)
	update_label()


func update_label() -> void:
	var prompts:int = calculate_clues()
	if prompts == -1:
		text = "Clues: ?"
	else:
		text = "Clues: " + str(prompts)

func calculate_clues() -> int:
	if player_data.size() == 0 or room_difficulty == 0:
		return -1
	
	var skill_age_sum:int
	for player in player_data.values():
		if player["skill"] == -1 or player["age"] == -1:
			return -1
		skill_age_sum += player["skill"] * player["age"]
	
	return round(room_difficulty * skill_age_sum / pow(player_data.size(), 2.3))

�extends Node

signal room_difficulty_updated(new_difficulty:int)

signal player_skill_updated(instance_id:int, new_skill:int)
signal player_age_updated(instance_id:int, new_age:int)

signal player_deleted(instance_id:int)
L�RSRC                     Theme            ��������                                            &      resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script    default_base_scale    default_font    default_font_size    Button/styles/focus    Button/styles/hover    Button/styles/normal    LineEdit/styles/focus    LineEdit/styles/normal           local://StyleBoxFlat_iagi1 �         local://StyleBoxFlat_p1qrt �         local://StyleBoxFlat_f362q �         local://StyleBoxEmpty_a5k0v *         local://StyleBoxFlat_b2fnw H         local://Theme_iyhqi }         StyleBoxFlat          ��Q? (W?�B�>  �?         StyleBoxFlat          ���>��A?��/?��^?         StyleBoxFlat          ��>f.(?80?  �?         StyleBoxEmpty             StyleBoxFlat           �>�X(?��4?  �?         Theme              !             "            #            $            %                  RSRC�7��SdL� ����RSRC                     PackedScene            ��������                                            B      Title    offset_bottom    CluesLabel    offset_top    ScrollContainer    anchor_top 	   modulate    resource_local_to_scene    resource_name    length 
   loop_mode    step    tracks/0/type    tracks/0/imported    tracks/0/enabled    tracks/0/path    tracks/0/interp    tracks/0/loop_wrap    tracks/0/keys    tracks/1/type    tracks/1/imported    tracks/1/enabled    tracks/1/path    tracks/1/interp    tracks/1/loop_wrap    tracks/1/keys    tracks/2/type    tracks/2/imported    tracks/2/enabled    tracks/2/path    tracks/2/interp    tracks/2/loop_wrap    tracks/2/keys    tracks/3/type    tracks/3/imported    tracks/3/enabled    tracks/3/path    tracks/3/interp    tracks/3/loop_wrap    tracks/3/keys    script    tracks/4/type    tracks/4/imported    tracks/4/enabled    tracks/4/path    tracks/4/interp    tracks/4/loop_wrap    tracks/4/keys    tracks/5/type    tracks/5/imported    tracks/5/enabled    tracks/5/path    tracks/5/interp    tracks/5/loop_wrap    tracks/5/keys    _data    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset 	   _bundled       Theme    res://ui.theme �C���:   Script    res://clues_label.gd ��������   Script    res://room_select.gd ��������   PackedScene    res://player_edit.tscn H��0   Script    res://player_add.gd ��������      local://Animation_q001i �         local://Animation_xy2qv ;
         local://AnimationLibrary_opmwu          local://LabelSettings_pdkv7 f         local://PackedScene_dd6ad �      
   Animation    	      o�:         value                                                                    times !                transitions !        �?      values                    update                value                                                                   times !                transitions !        �?      values                    update                value                                                                    times !                transitions !        �?      values            �>      update        !         value "          #         $               %         &         '               times !                transitions !        �?      values            �?  �?  �?  �?      update        (      
   Animation ,         	   start_up          value                                                                    times !          ���>      transitions !        �?  �?      values          ����             update                 value                                                                   times !      ��L>��?      transitions !        �?  �?      values          d                update                 value                                                                    times !      ���=   ?      transitions !        �?  �?      values       )   �������?     �>      update        !         value "          #         $               %         &         '               times !          ���>      transitions !        �?  �?      values            �?  �?  �?         �?  �?  �?  �?      update        )         value *          +         ,              -         .         /               times !      ��L>��?      transitions !        �?  �?      values            �?  �?  �?         �?  �?  �?  �?      update        0         value 1          2         3              4         5         6               times !      ���=   ?      transitions !        �?  �?      values            �?  �?  �?         �?  �?  �?  �?      update        (         AnimationLibrary    7               RESET              	   start_up          (         LabelSettings    :      0   ;        �?��|?��r?  �?(         PackedScene    A      	         names "   U      Main    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    theme    Control    AnimationPlayer 	   autoplay 
   libraries    BackgroundPanel    Panel    Title    anchor_left    offset_left    offset_right    text    label_settings    horizontal_alignment    vertical_alignment    Label    CluesLabel    unique_name_in_owner    anchor_top    script    ScrollContainer    follow_focus    horizontal_scroll_mode    MarginContainer %   theme_override_constants/margin_left $   theme_override_constants/margin_top &   theme_override_constants/margin_right '   theme_override_constants/margin_bottom    PlayerEntries    VBoxContainer    RoomContoller    HBoxContainer    RoomSelect    size_flags_horizontal 
   alignment 
   clip_text    OptionButton    RoomAdd    custom_minimum_size    Button    RoomDelete    HSeparator2 	   modulate    HSeparator    RoomNameEdit    placeholder_text 	   LineEdit 	   MinSteps    split_offset    dragger_visibility    HSplitContainer    MinStepsLabel    MinStepsEdit    SpinBox 	   MaxSteps    MaxStepsLabel    MaxStepsEdit 	   Duration    DurationLabel    DurationEdit 
   max_value    step    allow_greater    suffix    custom_arrow_step    select_all_on_focus    PlayerEdit 
   PlayerAdd    player_edit    _on_room_add_pressed    pressed    _on_room_delete_pressed     _on_room_name_edit_text_changed    text_changed !   _on_min_steps_edit_value_changed    value_changed !   _on_max_steps_edit_value_changed     _on_duration_edit_value_changed    	   variants    (                    �?                   	   start_up                                ����      ?   ��L>    �9�    �9C      Clues Calculator                   ��L?     ��     �B          	   Clues: 0               �>     @?               
      B          +       -      �?  �?  �?       
   Room name    �         Minmum steps:       Maximum steps:    
   Duration:      4D     �@      m                         node_count             nodes     �  ��������       ����                                                          	   	   ����   
                              ����                                                         ����                  	      	      
                                                                     ����                        	            	                                                                     ����
                  	            	                                                  ����                      !      "                 $   #   ����                          &   %   ����                    +   '   ����         (       )      *                       .   ,   ����   -                             .   /   ����   -                             2   0   ����   1                       5   3   ����               (       4      )                 9   6   ����         7      8                    :   ����                           <   ;   ����               )                 9   =   ����         7      8                    >   ����            !              <   ?   ����               )                 9   @   ����         7      8                    A   ����            "              <   B   ����	               C   #   D   $   E      )      F   %   G   $   H                 2   2   ����                    ���I   &                       .   J   ����   -                     '   K   &             conn_count             conns     *   
   	   M   L                 	   M   N                 	   P   O                 	   R   Q                 	   R   S                 	   R   T                    node_paths              editable_instances              version       (      RSRCy�6&���extends Button

@export var player_edit:PackedScene
@onready var player_entries: VBoxContainer = %PlayerEntries

func _ready() -> void:
	button_up.connect(on_button_press)

func on_button_press():
	player_entries.add_child(player_edit.instantiate())
	player_entries.move_child(self, player_entries.get_child_count())
�6extends OptionButton

func _ready() -> void:
	item_selected.connect(on_item_selected)
	GlobalSignals.player_age_updated.emit(
		owner.get_instance_id(), -1)

func on_item_selected(index:int) -> void:
	GlobalSignals.player_age_updated.emit(
		owner.get_instance_id(), get_item_id(index))
[RSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://player_skill_select.gd ��������   Script    res://player_age_select.gd ��������   Script    res://player_remove.gd ��������      local://PackedScene_j00gw t         PackedScene          	         names "         PlayerEdit    offset_right    offset_bottom    grow_horizontal    grow_vertical    columns    GridContainer    SkillSelect    layout_direction    layout_mode    size_flags_horizontal    item_count    popup/item_0/text    popup/item_0/id    popup/item_1/text    popup/item_1/id    popup/item_2/text    popup/item_2/id    popup/item_3/text    popup/item_3/id    script    OptionButton 
   AgeSelect    PlayerRemove    custom_minimum_size    text    Button    	   variants           ��C     �A                     	   Beginner             Intermediate       Experienced       Master                        Teen       Adult                
      B          -                node_count             nodes     X   ��������       ����                                                    ����         	      
                                                   	      
                           ����         	                                                            ����         	                            conn_count              conns               node_paths              editable_instances              version             RSRC>�˞\�ًextends Button

func _ready() -> void:
	button_up.connect(on_button_press)

func on_button_press() -> void:
	GlobalSignals.player_deleted.emit(owner.get_instance_id())
	owner.queue_free()
܇.�extends OptionButton

func _ready() -> void:
	item_selected.connect(on_item_selected)
	GlobalSignals.player_skill_updated.emit(
		owner.get_instance_id(), -1)

func on_item_selected(index:int) -> void:
	GlobalSignals.player_skill_updated.emit(
		owner.get_instance_id(), get_item_id(index))
�X�ɣ<lgK�V��RSRC                  	   Resource            ��������   RoomsResource                                                   resource_local_to_scene    resource_name    script    name 
   steps_min 
   steps_max 	   duration    rooms       Script    res://rooms_resource.gd ��������   Script    res://room_resource.gd ��������      local://Resource_f5u7d �         local://Resource_p78mq ?         local://Resource_r3rrn �         local://Resource_d6648 �      	   Resource                   ,      Jungle Quest                            	   Resource                   ,   
   The Vault                         -   	   Resource                   ,      Haunted Hideaway       
                  Z   	   Resource                                                      RSRC�X	��͸j���LLclass_name RoomsResource extends Resource

@export var rooms:Array[RoomResource]

func _init():
	rooms.clear()
�extends LineEdit

��1�	:�A�class_name RoomResource extends Resource

@export var name:StringName
@export var steps_min:int 
@export var steps_max:int 
@export var duration:int


func _init(_name = "New Room", _steps_min = 0, _steps_max = 0, _duration = 0):
	name = _name
	steps_min = _steps_min
	steps_max = _steps_max 
	duration = _duration
�>��class_name RoomSaver extends Node

@export var rooms:Array[RoomResource]

@onready var room_save:Button = $RoomSave
@onready var room_load:Button = $RoomLoad

func _ready() -> void:
	room_save.pressed.connect(on_room_save)
	room_load.pressed.connect(on_room_load)

func on_room_save() -> void:
	pass

func on_room_load() -> void:
	pass
extends OptionButton

const filepath:String = "res://rooms.tres"
var rooms_resource:RoomsResource = preload(filepath)

@onready var room_name_edit:LineEdit = %RoomNameEdit
@onready var min_steps_edit:SpinBox = %MinStepsEdit
@onready var max_steps_edit:SpinBox = %MaxStepsEdit
@onready var duration_edit:SpinBox = %DurationEdit

func _ready() -> void:
	item_selected.connect(on_item_selected)
	load_resource()
	update()
	on_item_selected(selected)

func on_item_selected(index:int) -> void:
	room_name_edit.text = rooms_resource.rooms[selected].name
	min_steps_edit.value = rooms_resource.rooms[selected].steps_min
	max_steps_edit.value = rooms_resource.rooms[selected].steps_max
	duration_edit.value = rooms_resource.rooms[selected].duration

func load_resource() -> void:
	for room in rooms_resource.rooms:
		add_item(room.name, 0)

func update() -> void:
	ResourceSaver.save(rooms_resource, filepath)
	calculate_difficuly()

func _on_room_add_pressed() -> void:
	var new_room:RoomResource = RoomResource.new()
	rooms_resource.rooms.append(new_room)
	add_item(new_room.name, 0)
	select(item_count - 1)
	update()
	on_item_selected(selected)

func _on_room_delete_pressed() -> void:
	var prev_selected = selected
	remove_item(selected)
	rooms_resource.rooms.pop_at(selected)
	if prev_selected - 1 >= 0:
		select(prev_selected - 1)
	else:
		select(item_count - 1)
	update()
	on_item_selected(selected)


func _on_room_name_edit_text_changed(new_text: String) -> void:
	set_item_text(selected, new_text)
	rooms_resource.rooms[selected].name = new_text
	update()

func _on_min_steps_edit_value_changed(value:int) -> void:
	rooms_resource.rooms[selected].steps_min = value
	update()

func _on_max_steps_edit_value_changed(value:int) -> void:
	rooms_resource.rooms[selected].steps_max = value
	update()

func _on_duration_edit_value_changed(value:int) -> void:
	rooms_resource.rooms[selected].duration = value
	update()


func calculate_difficuly() -> void:
	var difficulty_score:float = (
		rooms_resource.rooms[selected].duration *
		rooms_resource.rooms[selected].steps_max *
		abs(rooms_resource.rooms[selected].steps_max -
		rooms_resource.rooms[selected].steps_min + 1)
	)
	
	var id:int
	if difficulty_score < 5_000:
		id = 250
	elif difficulty_score < 10_000:
		id = 375
	else:
		id = 500
	
	if (
	rooms_resource.rooms[selected].duration == 0 or
	rooms_resource.rooms[selected].steps_max == 0 or
	rooms_resource.rooms[selected].steps_min == 0 ):
		id = 0
	
	set_item_id(selected, id)
	GlobalSignals.room_difficulty_updated.emit(id)
A�?��0�-+�RSCC      "  �   (�/�`" % b�(�Ei�����]o���#��;tk(mo�i�1v.z��=�[���P��&�r�G�7GJ������6�%����]���Z�J~�:��X��M�-]*�*�J�������0�`�t�?�� 	03�`��ț�f̀:�Z4{I���ao� �� RSCCΉ	�vI.F;�RSCC      �  �  (�/�`�} 6�G7P�&tB�|UUU�L���@]���ٛ�mB��[.h�f�Y��5d�:�N�����4 6 8 ]�����ǜ����dW������QlV��5�'n��(	!	��r����O�o��?��Or�0�����G��{T�-ٵl���p:�t���#ܚ�SbxW��_�/�c�0r9�8����J�#��Rw@IX�m��r��	k6�V5��<��#��Wq�h*��FY��G����p�;O��N(�	�D~�@S8�(�T���_�U�޸��(��WT9~t�"N��)R�h$M؂�r`"Ac� �	bLdgi��U�1���2u�,+2�"	����X�Uy"Q��(�9`��&|Y�:���tDCxE9��ĝ��)07��Ϙ%.��v�M�*#mTĜ����:^���EL������(܂��[���x�p���ݏ[����Z7vr�RSCC���r������ �RSCC      8  a  (�/�`8� V�Y@0q�E���XXt:�(X4

�z�x��6yO�%�ܭ�7Yb{?�����j��&ַ'�!�X�@ D E �'5�b������F�Ś�9����R�|y�d��!�&;q��?��/�<P"��� ��r8��?�/�)gj��c�X>�u�$#��J&��;^H!�DB8힇�u2f��Sn�6�Q����06�����#���	W�����B,�d%�L.�P4#���@�d�h.l�q��p�j�l�R�aG�uדm������f�YU�Û�TVT<(L�5lLt���AC�8��'ć���=���LV��PZ��R^��>�D@�	�D		2q��/1�BKc���D����rq��=I�I��`Cu� ]$�H@�R��3�mw��KJ2�P�&y5����CU)��3��	�Li���Q#���*�DJN��j�gT�ʵ(�W�;ć#B.�����߭,���jfF$l FI�N�C�Y$�� G�(���퇚�����o�#~߸��4�Q��ڭ>��	j��4��DH�f�����a��+��!@)R":I M����Ԇ�{��U��8�]RSCC��蓵t�[remap]

path="res://.godot/exported/133200997/export-f72dfba474b213710f83f5c350a04328-rooms.res"
���L�k0�g2�Of[remap]

path="res://.godot/exported/133200997/export-234ad4d8d43f2f55834435b9887da50b-main.res"
�Vʢ��ڔ�Ē�[remap]

path="res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn"
x�H{��TO:Ҁ��m[remap]

path="res://.godot/exported/133200997/export-1b26f2d686700fb76b7eb580d2a7e968-player_edit.scn"
 Bv��[remap]

path="res://.godot/exported/133200997/export-59fbf122d2f48b3420fcbc3e4894e060-rooms_presentation.res"
T   ��/U�0�O   res://main.tres���k�� 8   res://main.tscnH��0   res://player_edit.tscn�g�� .�;   res://rooms_presentation.tres�C���:   res://ui.themeE�}�8   res://ui_fancy.theme�ECFG	      application/config/name         PBL    application/run/main_scene         res://main.tscn    application/config/features$   "         4.0    Forward Plus        application/boot_splash/bg_color      ��>��>��>  �?"   application/boot_splash/show_image             application/config/icon         res://icon.svg     autoload/GlobalSignals          *res://global_signals.gd"   display/window/size/viewport_width      �  #   display/window/size/viewport_height      �  �gEr