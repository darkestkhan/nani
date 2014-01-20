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
with Lumen.Window;
with Lumen.Events.Animate;
with Lumen.GL;
use Lumen;

with Common;
use Common;

with Util;
procedure Nani is

  S: Integer := 2;
begin
  case S is
  when 3 .. 5 => Null;
  when 2 => Null;
  when others =>  Null;
  end case;

  Window.Create
    ( Util.Win,
      Width => Util.Screen_Width,
      Height => Util.Screen_Height,
      Name => "nani?"
    );

  Util.Win.Key_Press := Util.Key_Press'Access;

  Util.Init;
--  GL.Blend_Func (GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA);

  Events.Animate.Run
  ( Util.Win, Events.Animate.Frame_Count (Util.Screen_FPS),
    Util.New_Frame'Access
  );

  --Util.Free_Res;
end Nani;
