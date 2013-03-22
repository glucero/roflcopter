#!/usr/bin/env ruby

# requires ruby 2.0

require 'curses'
include Curses

init_screen
curs_set 0

begin
  frame = 0
  sound = Process.spawn %|say -v Alex the rofl copter says #{'siff ' * 10000}|

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

      setpos(5 + index, 0)
      copter = line + (' ' * (cols - 31))
      addstr copter.chars.rotate(-index + -frame).join
    end

    refresh
    sleep 0.08
  end
rescue Exception => error
  close_screen
  Process.kill 'KILL', sound if sound

  puts error.message, *error.backtrace
end

