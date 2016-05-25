# encoding: utf-8

class ProfilePictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
  
  before :cache, :convert_base64
  # convert the base 64 formate image
  def convert_base64(file)
    if file.respond_to?(:original_filename) &&
      file.original_filename.match(/^base64:/)
      fname = file.original_filename.gsub(/^base64:/, '')
      ctype = file.content_type
      decoded = Base64.decode64(file.read)
      file.file.tempfile.close!
      decoded = FilelessIO.new(decoded)
      decoded.original_filename = fname
      decoded.content_type = ctype
      file.__send__ :file=, decoded
    end
    file
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [64, 64]
  end


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  # def default_url
  #   asset_path("fallback/" + [:original, "profile_default_pic.jpg"].compact.join('_'))       
  # end

end
