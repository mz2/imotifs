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
	//DebugLog(@"Initialising alphabet with symbols");
	id eachObject;
	va_list argumentList;
	if (sym) {
		[symbols addObject:sym];
		va_start(argumentList, sym);
		while (eachObject = va_arg(argumentList, Symbol*)) {
			[symbols addObject: eachObject];
			//DebugLog(@"Adding symbol...");
		}
		va_end(argumentList);
	}
	
	return self;
}

- (id) initWithCoder:(NSCoder*) coder {
    DebugLog(@"Alphabet: initWithCoder");
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
    DebugLog(@"Alphabet: encodeWithCoder");
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
			Symbol* val = [[Symbol alloc]initWithNames:@"V",@"val",@"valine",nil];
			Symbol* leu = [[Symbol alloc]initWithNames:@"L",@"leu",@"leucine",nil];
			Symbol* ile = [[Symbol alloc]initWithNames:@"I",@"ile",@"isoleucine",nil];
			Symbol* met = [[Symbol alloc]initWithNames:@"M",@"met",@"methionine",nil];
			Symbol* phe = [[Symbol alloc]initWithNames:@"F",@"phe",@"phenylalanine",nil];
			Symbol* asn = [[Symbol alloc]initWithNames:@"N",@"asn",@"asparagine",nil];
			Symbol* glu = [[Symbol alloc]initWithNames:@"E",@"glu",@"glutamate",nil];
			Symbol* gln = [[Symbol alloc]initWithNames:@"Q",@"gln",@"glutamine",nil];
			Symbol* his = [[Symbol alloc]initWithNames:@"H",@"his",@"histidine",nil];
			Symbol* lys = [[Symbol alloc]initWithNames:@"K",@"lys",@"lysine",nil];
			Symbol* arg = [[Symbol alloc]initWithNames:@"R",@"arg",@"arginine",nil];
			Symbol* asp = [[Symbol alloc]initWithNames:@"D",@"asp",@"asparate",nil];
			Symbol* gly = [[Symbol alloc]initWithNames:@"G",@"gly",@"glycine",nil];
			Symbol* ala = [[Symbol alloc]initWithNames:@"A",@"ala",@"alanine",nil];
			Symbol* ser = [[Symbol alloc]initWithNames:@"S",@"ser",@"serine",nil];
			Symbol* thr = [[Symbol alloc]initWithNames:@"T",@"thr",@"threonine",nil];
			Symbol* tyr = [[Symbol alloc]initWithNames:@"Y",@"tyr",@"tyrosine",nil];
			Symbol* trp = [[Symbol alloc]initWithNames:@"W",@"trp",@"tryptophan",nil];
			Symbol* cys = [[Symbol alloc]initWithNames:@"C",@"cys",@"cysteine",nil];
			Symbol* pro = [[Symbol alloc]initWithNames:@"P",@"pro",@"proline",nil];
		
			protein = [[Alphabet alloc]initWithSymbols:
                       val,leu,ile,met,phe,
                       asn,glu,gln,his,lys,
                       arg,asp,gly,ala,ser,
                       thr,tyr,trp,cys,pro,nil];
			[protein setName: @"aminoacid"];
			//[protein->symbols];
		}
	}
	return protein;
}
@end
