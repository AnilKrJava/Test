package vc.thinker.cabbage;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.security.oauth2.provider.token.TokenStore;
import org.springframework.security.oauth2.provider.token.store.redis.RedisTokenStore;

import com.sinco.messager.redis.RedisMessageHandler;

import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import vc.thinker.cabbage.se.CabinetRemoteHandle;
import vc.thinker.utils.RedisCacheUtils;

@Configuration
@ConfigurationProperties(prefix="redis")
public class RedisConfig {
	
	@Value("${redis.host}")
	private String host;
	@Value("${redis.port}")
	private int port;
	@Value("${redis.timeout}")
	private int timeout;
	@Value("${redis.namespace}")
	private String namespace;
	@Value("${redis.password}")
	private String password;
	@Value("${redis.database}")
	private int database;
	@Value("${redis.message.database}")
	private int messageDatabase;
	@Value("${redis.oauth2.database}")
	private int oauthdatabase;
	
	@Bean(name="cabbageRedisPool")
	public JedisPool cabbageRedisPool(){
		JedisPoolConfig poolConfig=new JedisPoolConfig();
		poolConfig.setMaxTotal(20);
		poolConfig.setMinIdle(2);
		poolConfig.setMaxIdle(10);
		
		JedisPool pool = new JedisPool(poolConfig,host,port
				,timeout,password,database);
		return pool;
	}

	@Bean public RedisCacheUtils cacheUtils(@Qualifier("cabbageRedisPool") JedisPool cabbageRedisPool){
		return new RedisCacheUtils(namespace,cabbageRedisPool);
	}
	
	@Bean
	public RedisMessageHandler redisMessageHandler(){
		JedisPoolConfig poolConfig=new JedisPoolConfig();
		poolConfig.setMaxTotal(10);
		poolConfig.setMinIdle(2);
		poolConfig.setMaxIdle(5);
		JedisPool pool = new JedisPool(poolConfig,host,port
				,timeout,password,messageDatabase);
		RedisMessageHandler handler=new RedisMessageHandler(pool);
		return handler; 
	}
	
	@Bean
	public CabinetRemoteHandle cabinetRemoteHandle(@Qualifier("redisMessageHandler") RedisMessageHandler redisMessageHandler){
		CabinetRemoteHandle handle = new CabinetRemoteHandle();
		handle.setMessageHandler(redisMessageHandler);
		return handle;
	}
	
    @Bean
    public TokenStore tokenStore(){
		JedisPoolConfig config = new JedisPoolConfig();
		JedisConnectionFactory factory = new JedisConnectionFactory(config);
		factory.setHostName(host);
		factory.setPort(port);
		factory.setPassword(password);
		factory.setDatabase(oauthdatabase);
		factory.setTimeout(timeout);
		factory.afterPropertiesSet();
    	return new RedisTokenStore(factory);
    }


}
