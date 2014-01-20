pragma License (Modified_GPL);
------------------------------------------------------------------------------
-- EMAIL: <darkestkhan@gmail.com>                                           --
-- License: Modified GNU GPLv3 or any later as published by Free Software   --
--  Foundation (GMGPL, see COPYING file).                                   --
--                                                                          --
--                    Copyright © 2014 darkestkhan                          --
------------------------------------------------------------------------------
--  This Program is Free Software: You can redistribute it and/or modify    --
--  it under the terms of The GNU General Public License as published by    --
--    the Free Software Foundation: either version 3 of the license, or     --
--                 (at your option) any later version.                      --
--                                                                          --
--      This Program is distributed in the hope that it will be useful,     --
--      but WITHOUT ANY WARRANTY; without even the implied warranty of      --
--      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the        --
--              GNU General Public License for more details.                --
--                                                                          --
--    You should have received a copy of the GNU General Public License     --
--   along with this program.  If not, see <http://www.gnu.org/licenses/>.  --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
------------------------------------------------------------------------------
with Ada.Text_IO;
with System;

with Lumen.GL;
with Lumen.Shader;

with Common; use Common;
package body Util is

  ---------------------------------------------------------------------------

  package TIO renames Ada.Text_IO;

  ---------------------------------------------------------------------------

  Draw: GL.Enum := GL.GL_TRIANGLES;

  VS: GL.UInt;
  FS: GL.UInt;
  Program: GL.UInt;
  attribute_coord2d: GL.UInt;
  vbo_triangle: GL.UInt;

  Move_Cam_X: Float := 0.0;
  Move_Cam_X_Attrib: GL.UInt;
  Move_Cam_Y: Float := 0.0;
  Move_Cam_Y_Attrib: GL.UInt;
  Move_Cam_Z: Float := 0.0;
  Move_Cam_Z_Attrib: GL.UInt;
  Movement: constant Float := 0.1;

  ---------------------------------------------------------------------------

  procedure Put_Info (Prog: in GL.UInt)
  is
  begin
    TIO.Put_Line (Shader.Get_Info_Log (Prog));
  end Put_Info;

  ---------------------------------------------------------------------------

  procedure Key_Press
    ( Category  : Lumen.Events.Key_Category;
      Symbol    : Lumen.Events.Key_Symbol;
      Modifiers : Lumen.Events.Modifier_Set
    )
  is
  begin
    case Events.To_Character (Symbol) is
      when ASCII.ESC => Terminated := True;
      when 'q'  =>
        case Draw is
          when GL.GL_POINTS =>
            Draw := GL.GL_TRIANGLES;
          when GL.GL_TRIANGLES =>
            Draw := GL.GL_POINTS;
          when others => Null;
        end case;
      when 'a' =>
        Move_Cam_X := Move_Cam_X - Movement;
      when 'd' =>
        Move_Cam_X := Move_Cam_X + Movement;
      when 'w' =>
        Move_Cam_Y := Move_Cam_Y + Movement;
      when 's' =>
        Move_Cam_Y := Move_Cam_Y - Movement;
      when 'z' =>
        Move_Cam_Z := Move_Cam_Z + Movement;
      when 'x' =>
        Move_Cam_Z := Move_Cam_Z - Movement;
      when others => Null;
    end case;
  end Key_Press;

  procedure Update is
  begin
    Null;
  end Update;

  ---------------------------------------------------------------------------

  function New_Frame (Frame_Delta: in Duration) return Boolean
  is
    pragma Unreferenced (Frame_Delta);
  begin
    Update;
    Render (Win);
    return not Util.Terminated;
  end New_Frame;

  procedure Render (Win: in Window.Window_Handle)
  is
  begin
    GL.Clear_Color (0.0, 0.0, 0.0, 1.0);
    GL.Clear (GL.GL_COLOR_BUFFER_BIT);

    GL.Use_Program (Program);
    GL.Enable_Vertex_Attrib_Array (attribute_coord2d);

    GL.Bind_Buffer (GL.GL_ARRAY_BUFFER, vbo_triangle);
    GL.Vertex_Attrib_Pointer (attribute_coord2d, 3, GL.GL_FLOAT, GL.GL_FALSE, 0, System'To_Address (0));
    GL.Vertex_Attrib (Move_Cam_X_Attrib, Move_Cam_X);
    GL.Vertex_Attrib (Move_Cam_Y_Attrib, Move_Cam_Y);
    GL.Vertex_Attrib (Move_Cam_Z_Attrib, Move_Cam_Z);

    GL.Draw_Arrays (Draw, 0, 3);

    GL.Disable_Vertex_Attrib_Array (attribute_coord2d);

    Window.Swap (Win);
  end Render;

  ---------------------------------------------------------------------------

  procedure Init
  is
    use type GL.UInt;

    Triangle_Vertices: constant array (Natural range <>) of Float :=
      ( -0.8, 0.8, 1.0,
        -0.8, -0.8, -1.0,
        0.8, -0.8, 0.2
      );
    Success: Boolean;
  begin
    GL.Enable (GL.GL_BLEND);
    --GL.Enable (GL.GL_DEPTH_TEST);
    GL.Clear (GL.GL_COLOR_BUFFER_BIT or GL.GL_DEPTH_BUFFER_BIT);

    GL.Gen_Buffers (1, vbo_triangle'Address);
    GL.Bind_Buffer (GL.GL_ARRAY_BUFFER, vbo_triangle);
    GL.Buffer_Data (GL.GL_ARRAY_BUFFER, Triangle_Vertices'Length * (Float'Size / 8), Triangle_Vertices'Address, GL.GL_STATIC_DRAW);

    Shader.From_File (GL.GL_VERTEX_SHADER, "shaders/triangle.vert", VS, Success);
    if not Success then
      Put_Error ("Failed to load vertex shader");
    end if;
    GL.Compile_Shader (VS);

    Shader.From_File (GL.GL_FRAGMENT_SHADER, "shaders/triangle.frag", FS, Success);
    if not Success then
      Put_Error ("Failed to load vertex shader");
    end if;
    GL.Compile_Shader (FS);

    Program := GL.Create_Program;
    GL.Attach_Shader (Program, VS);
    GL.Attach_Shader (Program, FS);
    GL.Link_Program (Program);

    attribute_coord2d := GL.UInt (GL.Get_Attribute_Location (Program, "coord2d"));
    Move_Cam_X_Attrib := GL.UInt (GL.Get_Attribute_Location (Program, "Move_Cam_X"));
    Move_Cam_Y_Attrib := GL.UInt (GL.Get_Attribute_Location (Program, "Move_Cam_Y"));
    Move_Cam_Z_Attrib := GL.UInt (GL.Get_Attribute_Location (Program, "Move_Cam_Z"));
  end Init;

  ---------------------------------------------------------------------------

  procedure Free_Res is
  begin
    Null;
  end Free_Res;

  ---------------------------------------------------------------------------

end Util;
