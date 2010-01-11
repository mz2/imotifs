//
//  alphabet.m
//  objc
//
//  Created by Matias Piipari on 24/03/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Alphabet.h>
#import <Symbol.h>

@implementation Alphabet
- (id) init
{
    self = [super init];
    if (self != nil) {
        @throw [NSException exceptionWithName:@"IllegalnitMessageException" 
                                       reason:@"Use -initWithSymbols: instead" 
                                     userInfo:nil];
    }
    return self;
}

-(id) initWithSymbols:(Symbol*)sym, ... {
    [super init];
	symbols = [[NSMutableArray alloc] init];
	//PCLog(@"Initialising alphabet with symbols");
	id eachObject;
	va_list argumentList;
	if (sym) {
		[symbols addObject:sym];
		va_start(argumentList, sym);
		while (eachObject = va_arg(argumentList, Symbol*)) {
			[symbols addObject: eachObject];
			//PCLog(@"Adding symbol...");
		}
		va_end(argumentList);
	}
	
	return self;
}

- (id) initWithCoder:(NSCoder*) coder {
    PCLog(@"Alphabet: initWithCoder");
    NSString *n = [coder decodeObjectForKey:@"name"];
    Alphabet *alpha = [Alphabet withName:n];
    
    if (alpha == nil) {
        @throw [NSException exceptionWithName:@"IMUnknownAlphabetException" 
                                       reason:@"Only those alphabets registered in the name registry can be encoded/decoded" 
                                     userInfo:nil];
    }
    return alpha;
}

- (void) encodeWithCoder:(NSCoder*) coder {
    PCLog(@"Alphabet: encodeWithCoder");
    [coder encodeObject:name forKey:@"name"];
}

@synthesize name;
@synthesize symbols;

/*- (NSString*) name {
	return name;
}

- (void) setName:(NSString*) nameStr {
	name = nameStr;
}

-(NSArray*) symbols {
	return self->symbols;
}*/

- (int) index:(Symbol*) symbol {
	return [ [self symbols] indexOfObject:symbol ];
}

-(Symbol*) symbolWithName:(NSString*) n {
	for (Symbol* sym in [self symbols]) {
		if([sym hasName:n]) return sym;
	}
	
	return nil;
}

-(bool) containsSymbolWithName:(NSString*) n {
	for (Symbol* sym in [self symbols]) {
		if([sym hasName:n]) return true;
	}
	
	return false;	
}

- (void)dealloc {
	[name release];
	[symbols release];
	name = nil;
	symbols = nil;
	
	[super dealloc];
}

+(Alphabet*) withName:(NSString*) str {
	if ([[str lowercaseString] isEqualToString:@"dna"]) {
		return [Alphabet dna];
	} else if ([[str lowercaseString] isEqualToString:@"protein"]) {
		return [Alphabet protein];
	} else @throw [NSException exceptionWithName:@"InvalidAlphabetException"
                                          reason:[NSString stringWithFormat:@"No such alphabet %@", str]
                                        userInfo:nil];
}


+(Alphabet*) dna {
	static Alphabet* dna;
	@synchronized(self) {
		if (!dna) {
			Symbol* a = [[Symbol alloc] initWithNames:@"a",@"adenine",@"a",nil];
            [a setDefaultFillColor:[NSColor greenColor]];
			[a setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* c = [[Symbol alloc] initWithNames:@"c",@"cytosine",@"c",nil];
            [c setDefaultFillColor:[NSColor yellowColor]];
			[c setDefaultEdgeColor:[NSColor yellowColor]];
            Symbol* g = [[Symbol alloc] initWithNames:@"g",@"guanine",@"g",nil];
			[g setDefaultFillColor:[NSColor blueColor]];
            [g setDefaultEdgeColor:[NSColor blueColor]];
            Symbol* t = [[Symbol alloc] initWithNames:@"t",@"thymine",@"t",nil];
            [t setDefaultFillColor:[NSColor redColor]];
			[t setDefaultEdgeColor:[NSColor redColor]];
			dna = [[Alphabet alloc] initWithSymbols:a,c,g,t,nil];
			[dna setName: @"DNA"];
		}
	}
	return dna;

}

+(Alphabet*) protein {
	static Alphabet* protein;
	@synchronized(self) {
		if (!protein) {
			Symbol* val = [[Symbol alloc]initWithNames:@"v",@"val",@"valine",nil];
            [val setDefaultFillColor:[NSColor greenColor]];
			[val setDefaultEdgeColor:[NSColor greenColor]];
			Symbol* leu = [[Symbol alloc]initWithNames:@"l",@"leu",@"leucine",nil];
            [leu setDefaultFillColor:[NSColor greenColor]];
			[leu setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* ile = [[Symbol alloc]initWithNames:@"i",@"ile",@"isoleucine",nil];
            [ile setDefaultFillColor:[NSColor greenColor]];
			[ile setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* met = [[Symbol alloc]initWithNames:@"m",@"met",@"methionine",nil];
            [met setDefaultFillColor:[NSColor greenColor]];
			[met setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* phe = [[Symbol alloc]initWithNames:@"f",@"phe",@"phenylalanine",nil];
            [phe setDefaultFillColor:[NSColor greenColor]];
			[phe setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* asn = [[Symbol alloc]initWithNames:@"n",@"asn",@"asparagine",nil];
            [asn setDefaultFillColor:[NSColor magentaColor]];
			[asn setDefaultEdgeColor:[NSColor magentaColor]];
            Symbol* glu = [[Symbol alloc]initWithNames:@"e",@"glu",@"glutamate",nil];
            [glu setDefaultFillColor:[NSColor greenColor]];
			[glu setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* gln = [[Symbol alloc]initWithNames:@"q",@"gln",@"glutamine",nil];
            [gln setDefaultFillColor:[NSColor magentaColor]];
			[gln setDefaultEdgeColor:[NSColor magentaColor]];
            Symbol* his = [[Symbol alloc]initWithNames:@"h",@"his",@"histidine",nil];
            [his setDefaultFillColor:[NSColor magentaColor]];
			[his setDefaultEdgeColor:[NSColor magentaColor]];
            Symbol* lys = [[Symbol alloc]initWithNames:@"k",@"lys",@"lysine",nil];
            [lys setDefaultFillColor:[NSColor blueColor]];
			[lys setDefaultEdgeColor:[NSColor blueColor]];
            Symbol* arg = [[Symbol alloc]initWithNames:@"r",@"arg",@"arginine",nil];
            [arg setDefaultFillColor:[NSColor greenColor]];
			[arg setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* asp = [[Symbol alloc]initWithNames:@"d",@"asp",@"asparate",nil];
            [asp setDefaultFillColor:[NSColor redColor]];
			[asp setDefaultEdgeColor:[NSColor redColor]];
            Symbol* gly = [[Symbol alloc]initWithNames:@"g",@"gly",@"glycine",nil];
            [gly setDefaultFillColor:[NSColor orangeColor]];
			[gly setDefaultEdgeColor:[NSColor orangeColor]];
            Symbol* ala = [[Symbol alloc]initWithNames:@"a",@"ala",@"alanine",nil];
            [ala setDefaultFillColor:[NSColor orangeColor]];
			[ala setDefaultEdgeColor:[NSColor orangeColor]];
            Symbol* ser = [[Symbol alloc]initWithNames:@"s",@"ser",@"serine",nil];
            [ser setDefaultFillColor:[NSColor orangeColor]];
			[ser setDefaultEdgeColor:[NSColor orangeColor]];
            Symbol* thr = [[Symbol alloc]initWithNames:@"t",@"thr",@"threonine",nil];
            [thr setDefaultFillColor:[NSColor orangeColor]];
			[thr setDefaultEdgeColor:[NSColor orangeColor]];
            Symbol* tyr = [[Symbol alloc]initWithNames:@"y",@"tyr",@"tyrosine",nil];
            [tyr setDefaultFillColor:[NSColor greenColor]];
			[tyr setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* trp = [[Symbol alloc]initWithNames:@"w",@"trp",@"tryptophan",nil];
            [trp setDefaultFillColor:[NSColor greenColor]];
			[trp setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* cys = [[Symbol alloc]initWithNames:@"c",@"cys",@"cysteine",nil];
            [cys setDefaultFillColor:[NSColor greenColor]];
			[cys setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* sec = [[Symbol alloc]initWithNames:@"u",@"sec",@"selenocysteine",nil];
            [sec setDefaultFillColor:[NSColor greenColor]];
			[sec setDefaultEdgeColor:[NSColor greenColor]];
            Symbol* pro = [[Symbol alloc]initWithNames:@"p",@"pro",@"proline",nil];
            [pro setDefaultFillColor:[NSColor greenColor]];
			[pro setDefaultEdgeColor:[NSColor greenColor]];
            
			protein = [[Alphabet alloc]initWithSymbols:
                       val,leu,ile,met,phe,
                       asn,glu,gln,his,lys,
                       arg,asp,gly,ala,ser,
                       thr,tyr,trp,cys,sec,pro,nil];
			[protein setName: @"PROTEIN"];
			//[protein->symbols];
		}
	}
	return protein;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"[Alphabet:%@]",self.name];
}
@end
