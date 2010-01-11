require 'rexml/document'

# The XMS module provides input and output of annotated sequence motifs
# using the XMS file format.
#
# NOTE! Only the DNA alphabet is currently supported.
#
# Author::    Matias Piipari (mailto:matias.piipari@gmail.com)
# Copyright:: Copyright (c) 2009 Wellcome Trust Sanger Institute
# License::   LGPL v3

module XMS
  
  # Represents an ordered set of sequence motif objects.
  # The motif set also has a dictionary of key-value paired annotations.
  # Both annotations and motifs are mutable.
  class MotifSet
    attr_accessor :annotations
    attr_accessor :motifs
    
    # Takes an array of Motif objects as an array.
    def initialize(motifs)
      @motifs = motifs
      @annotations = {}
    end

    # Returns a REXML::Document object representation of the motif set
    # that follows the XMS format.
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

    # Returns a string representation of the motif set in the XMS format.
    def to_s
      self.toXML
    end
  end
  
  # A motif object contains the name, threshold, annotation and the model weight matrix object.
  # All its fields are mutable.
  class Motif
    attr_accessor :weightmatrix, :name, :threshold, :annotations
    
    # Arguments are a weight matrix (an XMS::WeightMatrix object),name (String) and threshold (float).
    def initialize(weightmatrix,name,threshold=0.0)
      @weightmatrix = weightmatrix
      @name = name
      @threshold = threshold
      @annotations = {}
    end
    
    # Returns a REXML::Element object containing an XMS formatted <motif> tag.
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
    
    # Returns a string containing an XMS formatted <motif> tag
    def to_s
      return self.toXML
    end
  end
  
  # A weight matrix object that contains an array of columns. 
  # Each column is an array of weights for each of the symobls in the alphabet, in the order A,C,G,T.
  #
  # NOTE! Only the DNA alphabet is currently supported.
  class WeightMatrix
    def initialize(columns)
      @columns = columns
    end
    
    # Returns a REXML::Element containing an XMS <weightmatrix> tag.
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
    
    # Returns a string containing an XMS <weightmatrix> tag.
    def to_s
      self.toXML
    end
  end
end
