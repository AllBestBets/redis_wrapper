require 'redis_wrapper/version'
require 'bundler'
Bundler.require
require 'rediscluster'

module RedisWrapper
  module RedisClusterFix
    class RedisClient
      def reconnect
      end
    end

    def client
      @client ||= RedisClient.new
    end
  end

  class Wrapper
    attr_accessor :is_cluster, :cluster_nodes

    def self.load(options = {})
      @@options = options.dup
    end

    def self.redis
      @@options[:is_redis_cluster] ? cluster_connection : Redis.new(@@options)
    end

    def self.cluster_connection
      @@options[:redis_cluster_nodes].each { |x| x.symbolize_keys! }
      cluster = RedisCluster.new(@@options[:redis_cluster_nodes])
      cluster.extend RedisClusterFix
      cluster
    end
  end
end
