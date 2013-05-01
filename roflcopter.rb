#!/usr/bin/env ruby

raise 'I require Ruby 2.0!' unless RUBY_VERSION['2.0']
raise 'I require OSX!' unless RUBY_PLATFORM['darwin']

require 'curses'
include Curses

init_screen
curs_set 0

begin
  frame = 0
  sound = Process.spawn *%w(say -v alex the rofl copter says), ('siff ' * 10000)

  # http://lodev.org/cgtutor/plasma.html
  # copter blade animations are created the same way you create a plasma
  # effect: we use the "propeller" and "rudder" variables as our palette and
  # replace each number with its corresponding palette character (offset by
  # the current animation frame number)

  propeller = 'ROFL:'
  rudder = 'L    '

  while (frame += 1)
    copter = [
      %|      4321043210LOL4321043210  |,
      %|                 ^             |,
      %| 012      /-------------       |,
      %|  3O3=======        [ ] \\     |,
      %|   210      \\            \\   |,
      %|             \\____________]   |,
      %|                  I     I      |,
      %|               --------------/ |
    ].map { |l| l + (' ' * (cols - l.length)) } # stretch to full terminal width

    # animate the propeller
    5.times do |iteration|
      copter[0].tr! iteration.to_s, propeller[-(iteration + frame) % 5]
    end

    # animate the rudder
    4.times do |iteration|
      copter[2..4].each do |line|
        line.tr! iteration.to_s, rudder[-(iteration + frame) % 5]
      end
    end

    copter.each_with_index do |line, index|
      setpos(lines / 3 + index, 0)
      addstr (line.chars.rotate -frame).join # rotate the line column-wise
    end

    refresh
    sleep 0.08
  end
rescue Exception => error
  close_screen
  Process.kill 'KILL', sound if sound

  puts error.message, *error.backtrace
end

