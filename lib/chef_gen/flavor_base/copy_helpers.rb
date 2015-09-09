module ChefGen
  # a base for ChefDK Template Flavors
  class FlavorBase
    # helpers to copy files from flavors and snippets to the temporary
    # directory; used in the setup phase
    module CopyHelpers
      private

      # copies content enqueued by the flavor and snippets to the
      # temporary directory.  Uses the list of things to copy in the
      # #tocopy list.  In each pair, src is an absolute file or
      # directory and dst is relative to the generator cookbook path.
      # If copying to the root of the temp dir, pair[1] can be nil.
      # Implemented using FileUtils::cp_r, so refer to that for details
      # of the different patterns you can use.
      # @return [void]
      # @api private
      def copy_content
        @tocopy.each do |pair|
          src = pair[0]
          dst = File.expand_path(File.join(@temp_path, pair[1] || ''))
          dstdir = File.dirname(dst)
          FileUtils.mkpath(dstdir) unless File.exist?(dstdir)
          FileUtils.cp_r(src, dst)
        end

        # clear out the list of things to copy so that snippets can
        # re-load it and call copy_content again if needed
        @tocopy = []
      end

      # returns the path to static content distributed with a flavor
      # @param file [String] the file to generate the path from
      # @return [String] the path the static content relative to the file
      # @api private
      def static_content_path(file)
        File.expand_path(
          File.join(
            File.dirname(file), '..', '..', '..', 'shared', 'flavor', self.class::NAME
          )
        )
      end
    end
  end
end
