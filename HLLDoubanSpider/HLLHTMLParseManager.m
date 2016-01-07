//
//  HLLHTMLParseManager.m
//  HLLCodingNetFramework
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLHTMLParseManager.h"
#import <Ono/ONOXMLDocument.h>

@implementation NSString (clear)

- (NSString *)removeSpaceAndNewline{
    
    NSString * temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
@end

@implementation HLLHTMLParseManager


static HLLHTMLParseManager *_instance;

+ (id)allocWithZone:(NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareParseManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
#pragma amrk - TOP250
- (void)parseasTOP250MovieWithHTMLData:(NSData *)data andError:(NSError *)error result:(void (^)(NSArray * movies, NSError *error))result{

    ONOXMLDocument * document = [ONOXMLDocument HTMLDocumentWithData:data error:&error];
//    //*[@id="content"]/div/div[1]/ol
    NSString * olPath = @"//*[@id=\"content\"]/div/div[1]/ol[@class=\"grid_view\"]";
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    NSMutableArray  * movies = [NSMutableArray array];
    ONOXMLElement * olELement = [document firstChildWithXPath:olPath];
    NSArray * olElementChildern = olELement.children;
    
    for (NSUInteger index = 0; index < olElementChildern.count; index ++) {
        HLLMovie * movie = [self hll_parseTOP250MovieWithTrElement:olELement index:index];
        [movies addObject:movie];
    }
    if (movies.count == 0) {
        if (result) {
            result(nil,error);
        }
    }else{
        if (result) {
            result(movies,nil);
        }
    }
}

- (HLLMovie *) hll_parseTOP250MovieWithTrElement:(ONOXMLElement *)element index:(NSUInteger)index{

//    //*[@id="content"]/div/div[1]/ol/li[1]
    NSMutableString * liXPath = [NSMutableString stringWithFormat:@"//li[%lu]",(unsigned long)index + 1];
    
    ONOXMLElement * liElement = [element firstChildWithXPath:liXPath];
    
    ONOXMLElement * rankElemnt = ({
//        //*[@id="content"]/div/div[1]/ol/li[1]/div/div[1]/em
        NSString * rankXPath = fullElementXPathWithFatherXPath(@"div/div[@class=\"pic\"]/em", liXPath);
        rankElemnt = [liElement firstChildWithXPath:rankXPath];
        NSLog(@"rank:%@",rankElemnt.stringValue);
        rankElemnt;
    });
    
    ONOXMLElement * imgElement = ({
//        //*[@id="content"]/div/div[1]/ol/li[1]/div/div[1]/a/img
        NSString * imgXPath = fullElementXPathWithFatherXPath(@"div/div[@class=\"pic\"]/a/img", liXPath);
        imgElement = [liElement firstChildWithXPath:imgXPath];
        NSLog(@"img:%@",imgElement.attributes[@"src"]);
        imgElement;
    });
    
    ONOXMLElement * nameElement = ({
//        //*[@id="content"]/div/div[1]/ol/li[1]/div/div[2]/div[1]/a
        NSString * nameXPath = fullElementXPathWithFatherXPath(@"div/div[@class=\"info\"]/div[@class=\"hd\"]/a", liXPath);
        nameElement = [liElement firstChildWithXPath:nameXPath];
        NSLog(@"name:%@",[nameElement.stringValue removeSpaceAndNewline]);
        nameElement;
    });
    
    ONOXMLElement * descElement = ({
//        //*[@id="content"]/div/div[1]/ol/li[1]/div/div[2]/div[2]/p[1]
        NSString * descXPath = fullElementXPathWithFatherXPath(@"div/div[@class=\"info\"]/div[@class=\"bd\"]/p[1]", liXPath);
        descElement = [liElement firstChildWithXPath:descXPath];
        NSLog(@"desc:%@",[descElement.stringValue removeSpaceAndNewline]);
        descElement;
    });
    
    ONOXMLElement * sroceElement = ({
        NSString * sroceXPath = fullElementXPathWithFatherXPath(@"div/div[@class=\"info\"]/div[@class=\"bd\"]/div[@class=\"star\"]/span[@class=\"rating_num\"]", liXPath);
        sroceElement = [liElement firstChildWithXPath:sroceXPath];
        NSLog(@"sroce:%@",sroceElement.stringValue);
        sroceElement;
    });
    
    ONOXMLElement * commitElement = ({
        NSString * commitXPath = fullElementXPathWithFatherXPath(@"div/div[@class=\"info\"]/div[@class=\"bd\"]/div[@class=\"star\"]/span[4]", liXPath);
        commitElement = [liElement firstChildWithXPath:commitXPath];
        NSLog(@"commit:%@",commitElement.stringValue);
        commitElement;
    });

    ONOXMLElement * quoteElement = ({
//        //*[@id="content"]/div/div[1]/ol/li[1]/div/div[2]/div[2]/p[2]/span
        NSString * quoteXPath = fullElementXPathWithFatherXPath(@"div/div[@class=\"info\"]/div[@class=\"bd\"]/p[@class=\"quote\"]/span[@class=\"inq\"]", liXPath);
        quoteElement = [liElement firstChildWithXPath:quoteXPath];
        NSLog(@"quote:%@",quoteElement.stringValue);
        quoteElement;
    });
    HLLMovie * movie = ({
        movie = [[HLLMovie alloc] init];
        movie.rank = [rankElemnt.stringValue intValue];
        movie.name = [nameElement.stringValue removeSpaceAndNewline];
        movie.img = imgElement.attributes[@"src"];
        movie.movieDesc = [descElement.stringValue removeSpaceAndNewline];
        movie.score = [sroceElement.stringValue floatValue];
        movie.commit = commitElement.stringValue;
        movie.quote = quoteElement.stringValue;
        movie;
    });
    return movie;
}

#pragma mark - 本周口碑榜
- (void) parseasWeekMovieWithHTMLData:(NSData *)data andError:(NSError *)error result:(void (^)(NSString * dateRangeContext ,NSArray * movies ,NSError * parseError))result{

    ONOXMLDocument * document = [ONOXMLDocument HTMLDocumentWithData:data error:&error];
    
    NSString * ulPath = @"//*[@id=\"content\"]/div/div[2]/div[@class=\"movie_top\"]/div[1]/ul[@id=\"listCont2\"]";
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    
    NSMutableArray  * movies = [NSMutableArray array];
    NSString * dateRangeContext;
    
    ONOXMLElement * ulElement = [document firstChildWithXPath:ulPath];
    NSArray * ulElementChildren = [ulElement children];
    
    for (NSUInteger index = 0 ; index < ulElementChildren.count; index ++) {
        ONOXMLElement * element = ulElementChildren[index];
        NSLog(@"+++---+++---+++---+++");
        if (index == 0) {//
            NSString * spanXPath = fullElementXPathWithFatherXPath(@"li/span", ulPath);
            ONOXMLElement * spanElement = [element firstChildWithXPath:spanXPath];
            dateRangeContext = spanElement.stringValue;
            NSLog(@"\t%@\t",dateRangeContext);
        }else{
            HLLRankMovie * movie = [self hll_parseWeekRankMovieWithTrElement:element index:index];
            NSLog(@"%d:%@",movie.rank,movie.name);
            [movies addObject:movie];
        }
    }
    if (movies.count == 0) {
        if (result) {
            result(dateRangeContext,nil,error);
        }
    }else{
        if (result) {
            result(dateRangeContext,movies,nil);
        }
    }
}

- (HLLRankMovie *) hll_parseWeekRankMovieWithTrElement:(ONOXMLElement *)element index:(NSUInteger)index{
    
    NSMutableString * liXPath = [NSMutableString stringWithFormat:@"//li[%lu]",(unsigned long)index + 1];
    
    ONOXMLElement * liElement = [element firstChildWithXPath:liXPath];
    
    ONOXMLElement * numberElement = ({
        NSString * numberXPath = fullElementXPathWithFatherXPath(@"div[@class=\"no\"]", liXPath);
        numberElement = [liElement firstChildWithXPath:numberXPath];
        numberElement;
    });
    
    ONOXMLElement * nameElement = ({
        NSString * nameXPath = fullElementXPathWithFatherXPath(@"div[@class=\"name\"]/a", liXPath);
        nameElement = [liElement firstChildWithXPath:nameXPath];
        nameElement;
    });
    
    ONOXMLElement * rangeElement = ({
        NSString * rangeXPath = fullElementXPathWithFatherXPath(@"span/div", liXPath);
        rangeElement = [liElement firstChildWithXPath:rangeXPath];
        rangeElement;
    });

    HLLRankMovie * movie = ({
        movie = [[HLLRankMovie alloc] init];
        movie.name = [nameElement.stringValue removeSpaceAndNewline];
        movie.rank = [numberElement.stringValue intValue];
        movie.rankStep = [rangeElement.stringValue intValue];
        movie.rankStatus = [rangeElement.attributes[@"class"] isEqualToString:@"up"] ? UP : DOWN;
        movie;
    });
    return movie;
}

#pragma mark - 电影新片榜
- (void) parseNewMovieWithHTMLData:(NSData *)data andError:(NSError *)error result:(void (^)(NSArray * movies ,NSError * parseError))result{

    ONOXMLDocument * document = [ONOXMLDocument HTMLDocumentWithData:data error:&error];
    
    NSString * xPath = @"//*[@id=\"content\"]/div/div[1]/div/div/table";
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    
    __block NSMutableArray  * movies = [NSMutableArray array];
    [document enumerateElementsWithXPath:xPath usingBlock:^(ONOXMLElement * tr, NSUInteger idx, BOOL *stop) {
        
        HLLMovie * movie = [self hll_parseNewMovieWithTrElement:tr index:idx];
        [movies addObject:movie];
        NSLog(@"%@",movie.name);
    }];
    if (movies.count == 0) {
        if (result) {
            result(nil,error);
        }
    }else{
        if (result) {
            result(movies,nil);
        }
    }
}

- (HLLMovie *) hll_parseNewMovieWithTrElement:(ONOXMLElement *)element index:(NSUInteger)index{
    
    NSMutableString * trXPath = [NSMutableString stringWithFormat:@"//table[%lu]/tr[@class=\"item\"]",(unsigned long)index + 1];
    
    ONOXMLElement * tr = ({
        tr = [element firstChildWithXPath:trXPath];
        tr;
    });
    
    ONOXMLElement * img = ({
        NSString * imgXPath = fullElementXPathWithFatherXPath(@"td/a[@class=\"nbg\"]/img", trXPath);
        img = [tr firstChildWithXPath:imgXPath];
        img;
    });
    
    ONOXMLElement * name = ({
        NSString * nameXPath = fullElementXPathWithFatherXPath(@"td/div[@class=\"pl2\"]/a", trXPath);
        name = [tr firstChildWithXPath:nameXPath];
        name;
    });
    
    ONOXMLElement * desc = ({
        NSString * descXPath = fullElementXPathWithFatherXPath(@"td/div[@class=\"pl2\"]/p[@class=\"pl\"]", trXPath);
        desc = [tr firstChildWithXPath:descXPath];
        desc;
    });
    
    ONOXMLElement * sroce = ({
        NSString * sroceXPath = fullElementXPathWithFatherXPath(@"td/div[@class=\"pl2\"]/div/span[@class=\"rating_nums\"]", trXPath);
        sroce = [tr firstChildWithXPath:sroceXPath];
        sroce;
    });
    
    ONOXMLElement * commit = ({
        NSString * commitXPath = fullElementXPathWithFatherXPath(@"td/div[@class=\"pl2\"]/div/span[@class=\"pl\"]", trXPath);
        commit = [tr firstChildWithXPath:commitXPath];
        commit;
    });
    
    HLLMovie * movie = ({
        movie = [[HLLMovie alloc] init ];
        movie.img = img.attributes[@"src"];
        movie.name = [name.stringValue removeSpaceAndNewline];
        movie.movieDesc = [desc.stringValue removeSpaceAndNewline];
        movie.score = [sroce.stringValue floatValue];
        movie.commit = commit.stringValue;
        movie;
    });
    return movie;
}

NSString * fullElementXPathWithFatherXPath(NSString * elementXPath ,NSString * fatherXPath){
    
    return [NSString stringWithFormat:@"%@/%@",fatherXPath,elementXPath];
}

@end
