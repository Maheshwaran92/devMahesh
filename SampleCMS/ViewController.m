//
//  ViewController.m
//  SampleCMS
//
//  Created by Vinoth Sridharan on 1/6/17.
//  Copyright © 2017 Vinoth Sridharan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *cmsTableView;
@property(nonatomic,strong)NSMutableArray *countryNameArray;
@property(nonatomic,strong)NSMutableArray *urlArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.countryNameArray=[[NSMutableArray alloc]init];
    self.urlArray=[[NSMutableArray alloc]init];
    [self getData];
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.cmsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cmsCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.countryNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"cmsCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.backgroundColor=[UIColor blueColor];
    }
    cell.textLabel.text=[self.countryNameArray objectAtIndex:indexPath.row
                         ];
    //
    NSURL *urlString = [NSURL URLWithString:[_urlArray objectAtIndex:indexPath.row]];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:urlString]])];
    UIImage *image = [UIImage imageWithData:imageData];
    
    cell.imageView.image=image;
    return cell;
    
}
-(void)getData
{
    
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url=[NSURL URLWithString:@"http://wptrafficanalyzer.in/p/demo1/first.php/countries/"];
    [
     [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        NSDictionary *receivedObj=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"Recevied Data is..%@",receivedObj);
        NSString *countryCapital=@"capital";
        NSArray *capital=[receivedObj objectForKey:@"countries"];
        if (capital.count>0) {
            for (int country=0; country<capital.count; country++)
            {
                NSString *capname=[[capital objectAtIndex:country]objectForKey:countryCapital];
                 NSString *imageUrl=[[capital objectAtIndex:country]objectForKey:@"flag"];
                
                if (capname!=nil) {
                    [_countryNameArray addObject:capname];
                    [_urlArray addObject:imageUrl];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cmsTableView reloadData];
        });
    }]resume];
}

    
    
    
    
    

@end
