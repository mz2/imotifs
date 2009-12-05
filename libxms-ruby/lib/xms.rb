require 'rexml/document'

module XMS
  class MotifSet
    attr_accessor :annotations
    attr_accessor :motifs

    def initialize(motifs)
      @motifs = motifs
      @annotations = {}
    end

    def toXML
      doc = REXML::Document.new
      motifsetnode = REXML::Element.new "motifset",doc
      @motifs.each {|m| m.toXML(motifsetnode)}
      motifsetnode.add_attribute REXML::Attribute.new("xmlns","http://biotiffin.org/XMS/")

      @annotations.each {|key,value|
        propnode = REXML::Element.new "prop",motifsetnode
        keynode = REXML::Element.new "key",propnode
        keynode.add_text key
        valuenode = REXML::Element.new "value",propnode
        valuenode.add_text value 
      }

      return doc
    end

    def to_s
      self.toXML
    end
  end

  class Motif
    attr_accessor :weightmatrix, :name, :threshold, :annotations

    def initialize(weightmatrix,name,threshold)
      @weightmatrix = weightmatrix
      @name = name
      @threshold = threshold
      @annotations = {}
    end

    def toXML(parent = nil)
      motifnode = REXML::Element.new "motif",parent
      namenode = REXML::Element.new "name",motifnode
      namenode.add_text @name 
      @weightmatrix.toXML(motifnode)
      thresholdnode = REXML::Element.new "threshold",motifnode
      thresholdnode.add_text @threshold.to_s
      @annotations.each {|key,value|
        propnode = REXML::Element.new "prop",motifnode
        keynode = REXML::Element.new "key",propnode
        keynode.add_text key
        valuenode = REXML::Element.new "value",propnode
        valuenode.add_text value
      }
      return motifnode
    end

    def to_s
      return self.toXML
    end
  end

  class WeightMatrix
    def initialize(columns)
      @columns = columns
    end

    def toXML(parent=nil)
      wmnode = REXML::Element.new("weightmatrix",parent)
      wmnode.add_attribute REXML::Attribute.new("alphabet","DNA")
      wmnode.add_attribute REXML::Attribute.new("columns",@columns.length.to_s)

      coli = 0
      @columns.each {|col|
        colnode = REXML::Element.new("column",wmnode)
        colnode.add_attribute REXML::Attribute.new("pos",coli.to_s)

        for i in 0..(col.length-1)
          symbol = nil
          if i == 0
            symbol = "adenine"
          elsif i == 1
            symbol = "cytosine"
          elsif i == 2
            symbol = "guanine"
          elsif i == 3
            symbol = "thymine"
          end
          wnode = REXML::Element.new("weight",colnode)
          wnode.add_attribute REXML::Attribute.new("symbol",symbol)
          wnode.add_text col[i].to_s
        end
        coli += 1
      }
      return wmnode
    end

    def to_s
      self.toXML
    end
  end
end

