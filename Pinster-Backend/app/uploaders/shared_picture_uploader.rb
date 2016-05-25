# encoding: utf-8

class SharedPictureUploader < CarrierWave::Uploader::Base

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
