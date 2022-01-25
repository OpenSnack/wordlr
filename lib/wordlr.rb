require_relative './helpers'

class Wordlr
    attr_reader :wordlist, :num_guesses, :current_guess

    def initialize(words, first_guesses)
        @orig_wordlist = words.map { |word| word.split('') }
        @wordlist = @orig_wordlist
        @num_guesses = 0
        @first_guesses = first_guesses
        @current_guess = nil
    end

    def reset
        @wordlist = @orig_wordlist
        @num_guesses = 0
        @current_guess = nil
    end

    def guess(letter_code)
        if @current_guess.nil? || letter_code == '.....'
            return @first_guesses[@num_guesses], @wordlist
        end

        correct_places = find_letter_indices(letter_code, '*')
        wrong_places = find_letter_indices(letter_code, '-')
        wrong_letters = find_letter_indices(letter_code, '.').map { |idx| @current_guess[idx] }

        good_words = valid_words(
            @wordlist,
            @current_guess,
            correct_places,
            wrong_places,
            wrong_letters
        )
        
        if good_words.length == 1
            return good_words[0].join, good_words
        end
    
        # the indices where wrong letters in the guess could go
        noncorrect_slots = [0,1,2,3,4] - correct_places

        letter_prominence = build_letter_prominence(good_words, noncorrect_slots)
        sorted = sort_by_prominence(good_words, letter_prominence, noncorrect_slots)

        return sorted[0][:word].join(''), sorted.map { |word| word[:word] }
    end

    def guess!(letter_code)
        out = guess(letter_code)
        @num_guesses += 1
        @current_guess = out[0]
        @wordlist = out[1]
    end
end
