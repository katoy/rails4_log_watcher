
# See
# http://tanihiro.hatenablog.com/entry/2014/01/09/193720
class Mydata
  include ActiveModel::Model

  attr_accessor :foo, :bar, :piyo

  validates :foo, presence: true
  validates :bar, presence: true
  validates :piyo, presence: true
end
