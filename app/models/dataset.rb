# frozen_string_literal: true

# The saved results of a given search, for analysis
#
# A dataset is a given set of searches, persisted in the database so that we
# can run digital humanities analyses on the returned collections of documents.
#
# @!attribute name
#   @raise [RecordInvalid] if the name is missing (`validates :presence`)
#   @return [String] The name of this dataset
# @!attribute user
#   @raise [RecordInvalid] if the user is missing (`validates :presence`)
#   @return [User] The user that owns this dataset
# @!attribute queries
#   @raise [RecordInvalid] if any of the queries are invalid
#     (`validates_associated`)
#   @return [Array<Datasets::Query>] The queries used to build this dataset
#     (`has_many`)
# @!attribute tasks
#   @return [Array<Datasets::Task>] The tasks run on this dataset (`has_many`)
class Dataset < ApplicationRecord
  validates :name, presence: true
  validates :user_id, presence: true

  belongs_to :user
  has_many :queries, class_name: 'Datasets::Query', dependent: :destroy
  has_many :tasks, class_name: 'Datasets::Task', dependent: :destroy

  # @return [String] string representation of this dataset
  def to_s
    name
  end
end
