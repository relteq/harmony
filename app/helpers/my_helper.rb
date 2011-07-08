# redMine - project management software
# Copyright (C) 2006  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

module MyHelper
  def progress_bar_display(sim)
    return nil if !sim.percent_complete
    percent = sim.percent_complete * 100

    if sim.succeeded != false
      bg_color = case percent 
        when 0..30 then "red"
        when 31..61 then "black"
        else "green"
      end

      width = [percent, 1].max

      content_tag(:td, 
        content_tag(:div, "&nbsp;",
                    :id => "progress_bar_sim_#{sim.id}", 
                    :class => "progress_bar #{bg_color}",
                    :style => "width: #{width}%;") +
        content_tag(:h5, "#{percent} %")
      )
    else
      content_tag(:td,
        content_tag(:p, "Failed",
                    :class => "status error")
      )
    end
  end
end
