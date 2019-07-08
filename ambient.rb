# Welcome to Sonic Pi v3.1

live_loop :ambi do
  sample :ambi_dark_woosh, amp: 0.6
  sleep 4
end

live_loop :drums do
  sample :bd_808
  sleep 1
end

live_loop :bass do
  use_synth :fm
  play choose(scale(:C1, :minor)), amp: 1.5
  sleep 0.5
end

mainchords = [chord(:C, :minor),
              chord(:G, :minor),
              chord(:F, :minor)]
extrachords = [chord(:Eb, :major),
               chord(:Ab, :major),
               chord(:D, :dim),
               chord(:Bb, :maj)]
dominantseventhchords = [[chord(:C, :minor7), chord(:F, :minor)],
                         [chord(:G, :minor7), chord(:C, :minor)]]

nextChord = nil

live_loop :chords do
  use_synth :hollow
  thisChord = nil
  if nextChord != nil
    thisChord = nextChord
    nextChord = nil
  elsif one_in(8)
    thisChord = choose(extrachords)
  elsif one_in(7)
    thisSequence = choose(dominantseventhchords)
    thisChord = thisSequence[0]
    nextChord = thisSequence[1]
  else
    thisChord = choose(mainchords)
  end
  
  puts(thisChord)
  
  play thisChord, amp: 1, sustain: 4
  use_synth :pluck
  speed = choose([1, 2, 4])
  with_fx :reverb do
    thisTune = thisChord.take(4)
    if one_in(4)
      thisTune = thisTune.shuffle
    end
    play_pattern_timed thisTune.stretch(speed), (1.0/speed), amp: 0.8
  end
end
