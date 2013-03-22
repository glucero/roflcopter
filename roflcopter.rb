#!/usr/bin/env ruby

raise 'I require Ruby 2.0!' unless RUBY_VERSION['2.0']
raise 'I require OSX!' unless RUBY_PLATFORM['darwin']

require 'curses'
include Curses

init_screen
curs_set 0

begin
  frame = 0
  sound = Process.spawn %|say -v alex the rofl copter says #{'siff ' * 10000}|

  while (frame += 1)
    [
      %|       4321043210LOL4321043210 |,
      %|                 ^             |,
      %|012      /-------------        |,
      %|3O3=======        [ ] \\        |,
      %|210      \\            \\        |,
      %|         \\____________]        |,
      %|            I     I            |,
      %|        --------------/        |
    ].each_with_index do |line, index|
      # the roflcopter blade animations are created the same way you create a
      # plasma effect. (http://lodev.org/cgtutor/plasma.html)
      5.times do |iteration|
        if index.zero?
          line.tr! iteration.to_s, %|ROFL:|[-(iteration + frame) % 5]
        end
      end
      4.times do |iteration|
        if (2..4) === index
          line.tr! iteration.to_s, %|L    |[(iteration + frame) % 4]
        end
      end

      # once the copter is created, white space is added to the end of each
      # line and the entire frame is rotated column-wise like a piano roll.
      setpos(5 + index, 0)
      copter = line + (' ' * (cols - 31))
      copter = copter.chars.rotate -(index + frame)
      addstr copter.join
    end

    refresh
    sleep 0.08
  end
rescue Exception => error
  close_screen
  Process.kill 'KILL', sound if sound

  puts error.message, *error.backtrace
end

