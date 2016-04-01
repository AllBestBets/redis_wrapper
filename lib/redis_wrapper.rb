require "redis_wrapper/version"
require "bundler"
Bundler.require
require "rediscluster"

module RedisWrapper
  # Backward compability with redis-rb
  module RedisClusterFix
    class RedisClient
      def reconnect
        # reconnect use in /config/unicorn.rb
        # after_fork do |server, worker|
        #   Redis.current.client.reconnect
        # TODO: need to implement this with RedisCluster ? 

        @client = nil
        cluster_connection
      end
    end

    def client
      @client ||= RedisClient.new
    end
  end

  class Wrapper
    attr_accessor :redis, :is_cluster, :cluster_nodes, :options

    def initialize(options = {})
      @options = options.dup

      if options[:is_redis_cluster] == true
        cluster_connection
      else
        @is_cluster = false
        @redis = Redis.new(options)
      end
    end

    def cluster_connection
      options[:redis_cluster_nodes].each { |x| x.symbolize_keys! }
      cluster = RedisCluster.new(options[:redis_cluster_nodes])
      cluster.extend RedisClusterFix
      @is_cluster = true
      @cluster_nodes = options[:redis_cluster_nodes]
      @redis = cluster
    end
  end
end
