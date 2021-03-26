package org.co2;

import java.util.Arrays;
import java.util.Iterator;
import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.util.GenericOptionsParser;



public class CO2 {
	
	public static void main(String[] args) throws Exception {
	
		Configuration config = new Configuration();
		String[] ourArgs = new GenericOptionsParser(config, args).getRemainingArgs();

		Job jobMP = Job.getInstance(config, "CO2 MapReduce");

		jobMP.setJarByClass(CO2.class);
		jobMP.setMapperClass(CO2Map.class);
		jobMP.setReducerClass(CO2Reduce.class);

		jobMP.setOutputKeyClass(Text.class);
		jobMP.setOutputValueClass(Text.class);
	

		FileInputFormat.addInputPath(jobMP, new Path(ourArgs[0]));
		FileOutputFormat.setOutputPath(jobMP, new Path(ourArgs[1]));

		if(jobMP.waitForCompletion(true))
			System.exit(0);
		System.exit(-1);
	}
}