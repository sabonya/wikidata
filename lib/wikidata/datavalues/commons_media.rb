module Wikidata
  module DataValues
    class CommonsMedia < Wikidata::DataValues::Value

      def to_s
        data_hash.imagename
      end

      def resolve!
        query = {image: data_hash.imagename, thumbwidth: 150}
        puts "Getting: #{query}".yellow if Wikidata.verbose?
        response = Nokogiri::XML(Faraday.get('http://tools.wmflabs.org/magnus-toolserver/commonsapi.php', query).body)
        @data_hash = Hashie::Mash.new(imagename: data_hash.imagename, file: picture_url(response),
          thumbnail: thumbnail_url(response))
      end

      def url
        resolved.file
      end

      def thumbnail
        resolved.thumbnail
      end

      private

      def picture_url(response)
        response.search('file')[1].try(:content)
      end

      def thumbnail_url(response)
        response.search('thumbnail')[0].try(:content)
      end
    end
  end
end
