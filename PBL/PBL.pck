GDPC                 �                                                                         X   res://.godot/exported/133200997/export-060d5e225f4707046c66412ccd3b872c-edit_player.scn �      �      �᝻48��V��s    P   res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn�      &      �X�a��)�@�҆_ڃ    \   res://.godot/exported/133200997/export-e1a68a9a74ee3f99cd578d8eff33bcee-edit_player_old.scn P      \      �Gc�Ӈ�
Ǿ��F�;    ,   res://.godot/global_script_class_cache.cfg          �       �F��9k�E�Ζ�0�
       res://.godot/uid_cache.bin  �&      �       �2D�R���p�A��       res://add_player.gd �       <      v���t=���jv&�       res://clues_label.gd�      �      a��6��, �!P$6Lo�       res://edit_player.tscn.remapP%      h       �E�y��	�_��Y��        res://edit_player_old.tscn.remap�%      l       � f����ѿ�WV��q       res://global_signals.gd �      �       (���X$��*�1�Sn
       res://main.tscn.remap   0&      a       �J�Sw� ������       res://player_age_select.gd  �             C���c���F����       res://player_level_select.gd�!      #      S��oU�5-OM�2�       res://project.binary�'      �      ;��>���ZZ�sx*��       res://remove_player.gd  #      �       j���<��������       res://room_level_select.gd  �#      �       �@��Ԫ.Xy���3       res://ui.theme  �$      �       �ȋ�]�~�*�UoU $    �J�list=Array[Dictionary]([{
"base": &"Label",
"class": &"CluesLabel",
"icon": "",
"language": &"GDScript",
"path": "res://clues_label.gd"
}])

�!extends Button

@export var player_row:PackedScene

@onready var player_entries: VBoxContainer = %PlayerEntries

func _ready() -> void:
	button_up.connect(on_button_press)

func on_button_press():
	player_entries.add_child(player_row.instantiate())
	player_entries.move_child(self, player_entries.get_child_count())
�+��class_name CluesLabel extends Label

var room_level:float

var player_levels:Dictionary
var player_ages:Dictionary


func _ready() -> void:
	GlobalSignals.room_level_updated.connect(on_room_level_updated)
	
	GlobalSignals.player_level_updated.connect(on_player_level_updated)
	GlobalSignals.player_age_updated.connect(on_player_age_updated)
	
	GlobalSignals.player_deleted.connect(on_player_deleted)
	update_label()

func on_room_level_updated(new_level:int) -> void:
	room_level = new_level / 100.0
	update_label()

func on_player_level_updated(instance_id:int, new_level:int) -> void:
	player_levels[instance_id] = new_level
	update_label()

func on_player_age_updated(instance_id:int, new_level:int) -> void:
	player_ages[instance_id] = new_level
	update_label()

func on_player_deleted(instance_id:int) -> void:
	player_levels.erase(instance_id)
	player_ages.erase(instance_id)
	update_label()


func update_label() -> void:
	var prompts:int = calculate_clues()
	if prompts == -1:
		text = "Clues: ?"
	else:
		text = "Clues: " + str(prompts)

func calculate_clues() -> int:
	if player_levels.size() == 0 or \
		player_ages.size() == 0 or \
		room_level == 0.0:
		return -1
		
	var level_age_sum:int
	
	for key in player_levels:
		if not player_levels.has(key) or not player_ages.has(key) or \
			player_levels.get(key) == -1 or player_ages.get(key) == -1:
			return -1
		level_age_sum += player_levels.get(key) * player_ages.get(key)
	
	return round(room_level * level_age_sum / player_levels.size())
 Z�w��C�)�j*��RSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://player_level_select.gd ��������   Script    res://player_age_select.gd ��������   Script    res://remove_player.gd ��������      local://PackedScene_2t336 t         PackedScene          	         names "         EditPlayer    offset_right    offset_bottom    grow_horizontal    grow_vertical    columns    GridContainer    LevelSelect    layout_direction    layout_mode    item_count    popup/item_0/text    popup/item_0/id    popup/item_1/text    popup/item_1/id    popup/item_2/text    popup/item_2/id    popup/item_3/text    popup/item_3/id    script    OptionButton 
   AgeSelect    RemovePlayer    custom_minimum_size    text    Button    	   variants           ��C     �A                     	   Beginner             Intermediate       Experienced       Master                        Teen       Adult                
      B          -                node_count             nodes     V   ��������       ����                                                    ����         	      
                                             	      
                           ����         	      
                                                      ����         	                            conn_count              conns               node_paths              editable_instances              version             RSRC�D k�:z&RSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://remove_player.gd ��������   Script    res://player_level_select.gd ��������      local://PackedScene_y3xnq B         PackedScene          	         names "         EditPlayer    layout_direction    dragger_visibility    HSplitContainer    RemovePlayer    custom_minimum_size    layout_mode    text    script    Button    SelectLevel    item_count    popup/item_0/text    popup/item_0/id    popup/item_1/text    popup/item_1/id    popup/item_2/text    popup/item_2/id    popup/item_3/text    popup/item_3/id    OptionButton    	   variants                   
      B                -                    	   Beginner             Medium        Experienced        Master                        node_count             nodes     9   ��������       ����                            	      ����                                          
   ����                                    	            
                                      conn_count              conns               node_paths              editable_instances              version             RSRC)@<eextends Node

signal room_level_updated(new_level:int)

signal player_level_updated(instance_id:int, new_level:int)
signal player_age_updated(instance_id:int, new_age:int)

signal player_deleted(instance_id:int)
鲮��-�a�}RSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name    default_base_scale    default_font    default_font_size    script    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset 	   _bundled       Script    res://room_level_select.gd ��������   PackedScene    res://edit_player.tscn ���2   Script    res://add_player.gd ��������   Script    res://clues_label.gd ��������      local://Theme_fl8y2 �         local://LabelSettings_pdkv7 �         local://PackedScene_en8oq �         Theme                      LabelSettings          0            PackedScene          	         names "   .      Main    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    theme    Control 
   ColorRect    color    ScrollContainer    anchor_left    anchor_top    follow_focus    horizontal_scroll_mode    MarginContainer %   theme_override_constants/margin_left $   theme_override_constants/margin_top &   theme_override_constants/margin_right '   theme_override_constants/margin_bottom    PlayerEntries    unique_name_in_owner    VBoxContainer    OptionButton    item_count    popup/item_0/text    popup/item_0/id    popup/item_1/text    popup/item_1/id    popup/item_2/text    popup/item_2/id    script    HSeparator    EditPlayer 
   AddPlayer    custom_minimum_size    text    player_row    Button    Title    label_settings    horizontal_alignment    vertical_alignment    Label    CluesLabel    	   variants                        �?                         ��$>��H>���>  �?   ����      ?     �>     @?                         Easy    !         Normal    2         Hard    B                      
      B          +             ��L>      Clues Calculator             ��L?   	   Clues: 0                node_count             nodes     �   ��������       ����                                                          	   	   ����                                       
                        ����
                        	            
                                            ����                                                  ����                                ����	                                                                      !   !   ����                    ���"                          '   #   ����   $            %             &                  ,   (   ����
                                       %      )      *      +                  ,   -   ����                                                         %      )                       conn_count              conns               node_paths              editable_instances              version             RSRC�끇���j!extends OptionButton

func _ready() -> void:
	item_selected.connect(on_item_selected)
	GlobalSignals.player_age_updated.emit(
		owner.get_instance_id(), -1)

func on_item_selected(index:int) -> void:
	GlobalSignals.player_age_updated.emit(
		owner.get_instance_id(), get_item_id(index))
pextends OptionButton

func _ready() -> void:
	item_selected.connect(on_item_selected)
	GlobalSignals.player_level_updated.emit(
		owner.get_instance_id(), -1)

func on_item_selected(index:int) -> void:
	GlobalSignals.player_level_updated.emit(
		owner.get_instance_id(), get_item_id(index))
W�����r~��@�extends Button

func _ready() -> void:
	button_up.connect(on_button_press)

func on_button_press() -> void:
	GlobalSignals.player_deleted.emit(owner.get_instance_id())
	owner.queue_free()
�f�	extends OptionButton

func _ready() -> void:
	item_selected.connect(on_item_selected)

func on_item_selected(index:int) -> void:
	GlobalSignals.room_level_updated.emit(
		get_item_id(index))
�RSCC        �   (�/�` � �(�Ei�뻻�2#��1ؽC���������]�;27��k���H�N@l�
���9^��'����8>(V�ئ�dtՒ��'�i=���mn1�RU�U�W�ώc�� D��:�e�?�`� }�4��l��Yk���E��t.?�`>��x XRSCC[remap]

path="res://.godot/exported/133200997/export-060d5e225f4707046c66412ccd3b872c-edit_player.scn"
'�L��@� [remap]

path="res://.godot/exported/133200997/export-e1a68a9a74ee3f99cd578d8eff33bcee-edit_player_old.scn"
��Jm[remap]

path="res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn"
��:����Y�����   �$���X   res://edit_player.tscn��{�~l5   res://edit_player_old.tscniqz$a�C2   res://main.tscnE�}�8   res://ui.theme^71��CYt   res://edit_player.tscn>O�8�	�<   res://edit_player.tscn���2   res://edit_player.tscn6��a�z�I�ECFG      application/config/name         PBL    application/run/main_scene         res://main.tscn    application/config/features$   "         4.0    Forward Plus       application/config/icon         res://icon.svg     autoload/GlobalSignals          *res://global_signals.gd"   display/window/size/viewport_width      �  #   display/window/size/viewport_height      �  ��