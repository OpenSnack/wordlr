#!/usr/bin/env ruby

require 'set'
require './lib/wordlr'

zero_guesses = ['soare', 'linty', 'chump']
valid_guesses = open('wordlist.txt').map { |s| s.chomp }
response = nil

wordlr = Wordlr.new(valid_guesses, zero_guesses)

loop do
    wordlr.guess!(response)
    puts wordlr.current_guess.upcase

    response = $stdin.gets.chomp
    if (Set['*****', '!'] === response)
        break
    end

    if (response.length != 5)
        puts 'Enter a valid guess'
        next
    end
end

puts "done in #{wordlr.num_guesses} guesses: #{wordlr.current_guess.upcase}"
