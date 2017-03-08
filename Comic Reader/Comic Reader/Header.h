//
//  Header.h
//  Comic Reader
//
//  Created by Tran Han on 2/15/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#ifndef Header_h
#define Header_h


#define CMHeightForNavigationbar 50.0
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CategoryDataName @"Category"
#define ComicDataName @"Comic"
#define Title @"title"


#define ID_CATEGORY @"idCategory"
#define ID @"id"
#define TOTAL_PAGE @"totalPage"
#define IS_DOWNLOADED @"isDownloaded"
#define CURRENT_DOWNLOADED @"currentDownloaded"
#define CURRENT_READED @"currentReaded"
#define IS_MYCOMIC @"isMyComic"
#define COMIC_PATH_TITLE @"comicPath"

#define PREDICATE_IS_MYCOMIC @"isMyComic == %@"
#define PREDICATE_ID_CATEGORY @"idCategory == %d"

#define TYPE_PARSE_JSON @"application/json"
#define HTTP_HEADER @"Accept"
#define COMIC_API @"http://172.20.23.10/ComicReader/category/list/%d/"
#define CATEGORY_API @"http://172.20.23.10/ComicReader/category/list/"
#define COMIC_DOWNLOAD_API @"http://172.20.23.10/ComicReader/images/1/1/1/"

#define CANT_SAVE @"Can't Save! %@ %@"
#define ERROR_RETRIEVING_CATEGORY @"Error Retrieving Category"
#define ERROR_RETRIEVING_COMIC @"Error Retrieving Comic"
#define ERROR_DOWNLOAD_COMIC @"Error Download comic"

#define NIB_CUSTOM_NAVIGATION_BAR @"CustomNavigationBar"
#define NIB_MAIN_CATEGORY_CELL @"MainCategoryCell"
#define NIB_SUB_CATEGORY_CELL @"SubCategoryCell"
#define NIB_PROGRESS_VIEW_DIALOG @"ProgressViewDialog"
#define NIB_COMIC_OVER_VIEW_DIALOG @"ComicOverViewDialog"
#define NIB_COMIC_OVER_VIEW_CELL @"ComicOverViewCell"
#define NIB_MENU_VIEW_DIALOG @"MenuViewDialog"



#define SEGUE_SHOW_COMIC_OVER_VIEW @"showComicOverView"
#define SEGUE_ON_CLICK_TABLE_CELL @"onClickTableCell"
#define SEGUE_ON_CLICK_DOWNLOAD @"onClickDownload"
#define SEGUE_ON_CLICK_MENU @"onClickMenu"
#define SEGUE_ON_CLICK_COMIC @"onClickComic"

#define ICON_NEW @"new.png"
#define ICON_STAR @"star.png"
#define ICON_COMIC @"comic.png"
#define ICON_ARROW @"arrow.png"
#define ICON_ARROW_HIGHLIGHT @"arrowhighlight.png"

#define ADD_FAV_COMIC @"Thêm truyện ưa thích"
#define REMOVE_FAV_COMIC @"Xoá truyện ưa thích"

#define BUTTON_OK @"OK"







#endif /* Header_h */
