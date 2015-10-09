
module RLetters
  module Visualization
    # Code to generate a classic Wordle-style word cloud
    module WordCloud
      extend ActiveSupport::Concern
      include PDF

      # Draw a word cloud for the given words
      #
      # @param [String] header the header to place at the top of the page
      # @param [Hash<String, Integer>] words a map from words to frequencies
      # @param [String] color the color palette to use to color the words
      #   Taken from the `ColorBrewer` namespace; should probably be one of
      #   'Purples', 'Blues', 'Greens', 'Oranges', 'Reds', or 'Greys'. Defaults
      #   to 'Blues'.
      # @param [String] font the font to use for the words (see `PDF`)
      #   Defaults to 'Roboto'.
      def word_cloud(header, words, color = 'Blues', font = 'Roboto')
        if words.size < 3
          color_size = 3
        elsif words.size > 9
          color_size = 9
        else
          color_size = words.size
        end

        # This will raise an exception if you pass a color ramp that doesn't
        # exist in ColorBrewer.
        colors = ColorBrewer::SEQUENTIAL_COLOR_SCHEMES[color_size].fetch(color)

        # Write out to PDF and return the PDF
        pdf_with_header(header) do |pdf|
          # Get the path to the font file itself. Again, it'll raise if you
          # pass a bad font.
          font_path = pdf.font_families.fetch(font)[:normal]

          # Get our point sizes for each word
          range = (words.values.min..words.values.max)
          words_to_points = words.each_with_object({}) do |(word, freq), ret|
            ret[word] = point_size_for(range, freq)
          end

          # Build the canvas and place the words
          canvas = Canvas.new(words_to_points, font_path)
          positions = words_to_points.each_with_object({}) do |(word, size), ret|
            ret[word] = [canvas.place_word(word, size), size]
          end

          pdf.font(font)

          # Compute how much space we have and how we should scale from our
          # canvas to the PDF
          space_x = pdf.bounds.width
          space_y = pdf.bounds.height - 18 - 20

          scale_x = space_x / canvas.width
          scale_y = space_y / canvas.height
          scale = [scale_x, scale_y].min

          # Center the block of text
          x_offset = y_offset = 0
          if scale == scale_x
            y_offset = (space_y - scale * canvas.height) / 2
          else
            x_offset = (space_x - scale * canvas.width) / 2
          end

          # Draw all the words, stroked in the darkest color from the color
          # scheme
          pdf.stroke_color(colors.last[1, 6])
          pdf.line_width(0.25)

          positions.each_with_index do |(word, (pos, size)), i|
            pdf.fill_color(colors[i % colors.size][1, 6])
            pdf.text_rendering_mode(:fill_stroke) do
              pdf.draw_text(word, size: size * scale,
                                  at: [pos[0] * scale + x_offset,
                                       pos[1] * scale + y_offset])
            end
          end
        end
      end

      private

      # Get the point size for a given word frequency
      #
      # We return font sizes between 8 and 28, to keep the canvas from getting
      # insanely big. This clamps the size range a bit, but that's okay.
      #
      # @param [Range] frequency_range the range of frequencies
      # @param [Integer] frequency the frequency of this word
      # @return [Integer] the point size at which to draw this word
      def point_size_for(frequency_range, frequency)
        relative = (frequency - frequency_range.min) /
                   (frequency_range.max - frequency_range.min)

        relative * 20.0 + 8
      end
    end
  end
end