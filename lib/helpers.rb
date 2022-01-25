# get all indices of a string that are the same as the symbol
def find_letter_indices(str, sym)
    out = []
    i = -1
    while i = str.index(sym, i + 1)
        out.push(i)
    end
    out
end

def valid_words(wordlist, guess, correct_places, wrong_places, wrong_letters)
    # get words where the letters in the correct places are the same as the guess
    correct_place_words = wordlist.select { |word| correct_places.all? { |idx| guess[idx] == word[idx] } }

    # the indices where wrong letters in the guess could go
    noncorrect_slots = [0,1,2,3,4] - correct_places
    
    # letters in the bot's guess that are -somewhere- in noncorrect_slots but not at the index they're at
    wrong_place_letters = guess.split('').map.with_index { |l, i| [l, i] }.select { |l, i| wrong_places.include? i }

    correct_place_words.select do |word|
        # find letters in the list word in places where wrong letters could go
        list_wrong_place_letters = word.map.with_index { |l, i| [l, i] }.select { |l, i| noncorrect_slots.include? i }
        # if any letters in list_wrong_place_letters are in wrong_letters, this word is bad
        # if any letters in list_wrong_place_letters are in the same spot in wrong_place_letters, this word is bad
        if list_wrong_place_letters.any? { |ll, li| wrong_letters.include?(ll) || wrong_place_letters.find { |wl, wi| ll == wl && li == wi } }
            false
        else
            good_word = true
            # remove letters from list_wrong_letters that are in wrong_place_letters. if we can't, this word is bad
            for l, i in wrong_place_letters
                list_idx = list_wrong_place_letters.find_index { |ll, li| ll == l }
                if !list_idx.nil?
                    list_wrong_place_letters.delete_at list_idx
                else
                    good_word = false
                end
            end
            good_word
        end
    end
end

def build_letter_prominence(words, use_indices)
    letter_prominence = {}
    words.each do |word|
        use_indices.each do |idx|
            if !letter_prominence.key? word[idx]
                letter_prominence[word[idx]] = 1
            else
                letter_prominence[word[idx]] += 1
            end
        end
    end
    letter_prominence
end

def sort_by_prominence(words, letter_prominence)
    words_by_prominence = words.map do |word|
        {
            word_string: word.join(''),
            num_unique_letters: word.uniq.length,
            prominence: word.map { |letter| letter_prominence[letter] }.sum
        }
    end

    words_by_prominence.sort do |a, b|
        if a[:num_unique_letters] != b[:num_unique_letters]
            b[:num_unique_letters] - a[:num_unique_letters]
        else
            b[:prominence] - a[:prominence]
        end
    end
end
