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
    

public class CO2Reduce extends Reducer<Text, Text, Text, Text> {
	
	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
		
		String malus_bonus;
		String rejet;
		String cout;
		
		int sumBonus_Malus = 0;
		int sumRejet = 0;
		int sumCout = 0;

		int count = 0;
		int avgMalus_Bonus = 0;
		int avgRejet = 0;
		int avgCout = 0;

		Iterator<Text> i = values.iterator();

		while(i.hasNext()) {
			String node = i.next().toString(); 

			System.err.print(key);
			System.err.print("	");
			System.err.println(node);
			//on sépare les 3 colonnes
			String[] splitted_node = node.split("\\|"); 
			malus_bonus = splitted_node[0];
			rejet = splitted_node[1];
			cout = splitted_node[2];
			//on ajoute les valeurs
			sumBonus_Malus += Integer.parseInt(malus_bonus);
			sumRejet += Integer.parseInt(rejet);
			sumCout += Integer.parseInt(cout);
			//on compte les voitures par key

			count++;
		}
		//on calcule les moyennes
		avgMalus_Bonus = sumBonus_Malus/count;
		avgRejet = sumRejet/count;
		avgCout = sumCout/count;
		//on écrit les moyennes pour chaque key
		context.write(key, new Text(avgMalus_Bonus + "\t" + avgRejet + "\t" + avgCout));
	}
}