#!/usr/bin/env ruby
require 'xms'

module WMC

  # The WMC::BulykParser parses motif set files where there is a header line
  # containing the motif name, followed by lines of symbol weights, each line 
  # containing either a nucleotide name and weights for all columnfs for that nucleotide,
  # or rows in the symbol order A,C,G,T.
  class BulykParser
    attr_accessor :motifset
    attr_accessor :namelinepattern
    attr_accessor :nukelinepattern
    attr_accessor :normalize
    attr_accessor :nukenameincluded
    
    # If nukenameincluded is true the first captured group from nukelinepat is the nucleotide name, 
    # the 2nd captured group contains the weights separated by any whitespace characters (/\s+/).
    #
    # If nukenameincluded is false the first capture match from nukelinepat is the weight for the nucleotide in question,
    # 1st captured group is a separated list of the weights and rows for motif are assumed to be in order A,C,G,T.
    def initialize(nukelinepat,namelinepat=/(.*)/,normalize=false,nukenameincluded=true)
      @motifset = nil
      @nukelinepattern = nukelinepat 
      @namelinepattern = namelinepat
      @normalize = normalize 
      @nukenameincluded = nukenameincluded
    end

    def make_pwm(weights)
      cols = []

      raise "Unexpected alphabet count : #{@weights.length}" unless weights.length == 4
      exp_weight_count = weights[0].length
      weights.each {|ws| 
        raise "Unexpected count of weights : #{ws.length} (expected = #{exp_weight_count})" if ws.length != exp_weight_count
      }

      (0..weights[0].length-1).each {|i|
        if normalize
          f = weights[0][i] + weights[1][i] + weights[2][i] + weights[3][i]
          if f > 0
            col = [weights[0][i]/f, weights[1][i]/f, weights[2][i]/f, weights[3][i]/f]
          else
            col = [0.25,0.25,0.25,0.25]
          end
        else
          col = [weights[0][i],weights[1][i],weights[2][i],weights[3][i]]
        end
        cols << col

        #$stderr.puts "cols: #{cols.length}"
      }

      return XMS::WeightMatrix.new(cols)
    end

   # Parses an input file, after which the motifset property of this parser
   # object will contain an XMS::WeightMatrix object with all the parsed motifs.
   def parse(inputf)
      @motifs = []
      @motif = nil
      @wm = nil
      @weights = [[]]*4 #[[A1,A2,..],[C1,C2,.],[...],[...]]
      @nukeindex = 0
      
      @name = nil
      @prevname = nil
      @cols = nil
      
      @weights_parsed = false

      inputf.each_line {|line|
        next if line.length < 2 #skip empty lines
        
        if line =~ @nukelinepattern
          #$stderr.puts "nuke line: #{line}"
          if nukenameincluded
            nukename = ($1).capitalize
            #$stderr.puts "Weight line : #{line}"
            line = $2
          else
            line = $1
            if @nukeindex == 0
              nukename = "A"  
            elsif @nukeindex == 1
              nukename = "C"
            elsif @nukeindex == 2
              nukename = "G"
            elsif @nukeindex == 3
              nukename = "T"
            else
              raise "Unexpected number of symbols: #{@nukeindex}"
            end
          end
          
          line = line.split(/\s+/)
          #line.delete_at 0 #drop nuke name
          #puts "#{nukename}:#{line.join(',')}"
          ws = line.map {|w| w.to_f}
          #$stderr.puts "ws : #{ws.length}"
          if nukename == "A"
            @weights[0] = ws
          elsif nukename == "C"
            @weights[1] = ws
          elsif nukename == "G"
            @weights[2] = ws
          elsif nukename == "T"
            @weights[3] = ws
          else
            raise "Unexpected nuke : #{nukename}"
          end
          
          @nukeindex += 1
          
          @weights_parsed = true if @nukeindex == 4 #if all nukes have been parsed
        else 
          raise "Unexpected line:#{line} (not a nuke nor a name line)" unless line =~ @namelinepattern
          @prevname = @name
          @name = $1
          @nukeindex = 0

          @weights_parsed = true
          @weights.each {|ws|
            #$stderr.puts "WS.length : #{ws.length}" 
            if ws.length == 0
              @weights_parsed = false
              break
            end
          }

          
        end

        if @weights_parsed
          #$stderr.puts "weights parsed (#{@weights.length} alphabet). Column count: #{@weights[0].length}" 
          @wm = make_pwm(@weights)
          @motif = XMS::Motif.new @wm, @name, 0.0
          @motifs << @motif
          @weights = [[]] * 4
          @weights_parsed = false
        end
      }

      #then add the last one in
      #@wm = XMS::WeightMatrix.new @cols
      #@motifs << XMS::Motif.new(XMS::WeightMatrix.new(@cols), @name, 0.0)
      
      @motifset = XMS::MotifSet.new @motifs
    end

  end

end
