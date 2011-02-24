class Simulation
  attr_accessor :name, :type, :started, :status, :progress

  def self.all_for_user(user_id)
    @response = self.http_get_batches(user_id)
    @response["batches"] if @response["status"] == "ok"
  end

private
  def self.http_get_batches(user, host = "localhost")
    YAML.load Net::HTTP.get(host, "/user/#{user}", 4567)
  end

  def self.http_get_batch(batch_id, host = "localhost")
    YAML.load Net::HTTP.get(host, "/batch/#{batch_id}", 4567)
  end
end
