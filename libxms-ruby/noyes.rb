module WMC
  class NoyesParser
    attr_accessor :motifset
    attr_accessor :nukelinepattern
    attr_accessor :namepattern
    attr_accessor :normalize
    
    def initialize(inputf, nukelinepattern = /(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/, namepattern = />(\S*)\t(\d+)(.*)/, normalize = true)
      #0  0 0 30
      @nukelinepattern = nukelinepattern

      #>Dstat.old  9 PSEUDO_COUNT 1.0
      @namepattern = namepattern
      @normalize = true
      @motifset = nil 
    end 

    def parse(inputf)
      cols = []
      motifs = []
      name = ""
      inputf.each_line {|line|
        if line =~ /^<$/ #end of record is a line with just '<' on it
          wm = XMS::WeightMatrix.new cols
          motif = XMS::Motif.new wm,name,0.0
          motifs << motif
          cols = []
        elsif line =~ @namepattern
          name = $1
        elsif line =~ @nukelinepattern

          col = [$1.to_f,$2.to_f,$3.to_f,$4.to_f]

          if @normalize
            f = col.inject(0.0) {|acc,val| acc+val}
            col = col.map {|v| v / f}
          end

          cols << col 
        end 
      }   
      @motifset = XMS::MotifSet.new motifs
    end 
  end
end
