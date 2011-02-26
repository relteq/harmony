class Simulation
  attr_accessor :name, :type, :started, :status, :progress

  def self.all_for_user(user_id)
    begin
      response = self.http_get_batches(user_id)
      if response["status"] == "ok"
        response["batches"].map{|s| s[:progress] = s[:n_complete] / s[:n_runs]}
        #response["batches"].map{|s| s[:progress] = rand(100)}
        return response["batches"]
      else
        response = []
      end
    rescue
      response = []
    end
  end

private
  def self.http_get_batches(user, host = "localhost")
    YAML.load Net::HTTP.get(host, "/user/#{user}", 4567)
  end

  def self.http_get_batch(batch_id, host = "localhost")
    YAML.load Net::HTTP.get(host, "/batch/#{batch_id}", 4567)
  end
end
