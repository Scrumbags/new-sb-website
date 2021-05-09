# Runs during jekyll build

require 'rss'
require 'open-uri'

module Jekyll
  class RssFeedCollector < Generator
     safe true
     priority :high
     def generate(site)

        # TODO: Insert code here to fetch RSS feeds
        # https://scrumbags.podcaster.de/scrumbags.rss
        #rss_item_coll = null;

        url = 'https://scrumbags.podcaster.de/scrumbags.rss'
        #print url
        #print "hallo"
        #open(url) do |rss|
        #  feed = RSS::Parser.parse(rss)
        #  rss_item_coll = feed
          #rss_item_coll = feed.items
          #print rss_item_coll
        #end
        open(url) do |rss|
          feed = RSS::Parser.parse(rss)
          rss_item_coll = feed.items
          
          # Create a new on-the-fly Jekyll collection called "external_feed"
          jekyll_coll = Jekyll::Collection.new(site, 'external_feed')
          site.collections['external_feed'] = jekyll_coll

          # Add fake virtual documents to the collection
          rss_item_coll.each do |item|
             title = item[:title]
             content = item[:content]
             guid = item[:guid]
             path = "_rss/" + guid + ".md"
             path = site.in_source_dir(path)
             doc = Jekyll::Document.new(path, { :site => site, :collection => jekyll_coll })
             doc.data['title'] = title;
             doc.data['feed_content'] = content;
             jekyll_coll.docs << doc
          end
       end
     end
  end
end
