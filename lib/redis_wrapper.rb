require "redis_wrapper/version"
require "bundler"
Bundler.require
require "rediscluster"

module RedisWrapper

  module ConnectionTableFix
    attr_accessor :pid
  end

  module RedisClusterFix
    attr_accessor :connections

    # Backward compability with redis-rb
    class RedisClient
      attr_accessor :cluster

      def reconnect
        @cluster.connections.pid = Process.pid
      end
    end
    
    def client
      @client ||= RedisClient.new
    end
  end

  class Wrapper
    attr_accessor :redis, :is_cluster, :cluster_nodes
    def initialize(options = {})
      if options[:is_redis_cluster] == true
        options[:redis_cluster_nodes].each{|x| x.symbolize_keys!}
        cluster = RedisCluster.new(options[:redis_cluster_nodes])
        cluster.extend RedisClusterFix
        cluster.connections.extend ConnectionTableFix
        
        @is_cluster = true
        @cluster_nodes = options[:redis_cluster_nodes]
        @redis = cluster
        @redis.client.cluster = cluster;
      else
        @is_cluster = false
        @redis = Redis.new(options)
      end
    end
  end
end
