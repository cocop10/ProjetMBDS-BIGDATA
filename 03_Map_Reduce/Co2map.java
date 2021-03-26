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

	
public class CO2Map extends Mapper<Object, Text, Text, Text> {
			
	protected void map(Object key, Text value, Context context) throws IOException, InterruptedException {

		if (value.toString().contains("Marque")){ // saute la première ligne
		}

		String line = value.toString(); 
		line = line.replaceAll("\\u00a0"," ");
		
		String[] splitted_line = line.split(","); 

		// colonne marque
		String marque;
		String[] splitted_space = splitted_line[1].split("\\s+"); 
		marque = splitted_space[0];

		marque = marque.replace("\"", "");

		// colonne Malus/Bonus
        String malus_bonus = splitted_line[2];

		malus_bonus = malus_bonus.replaceAll(" ", "").replace("€1", "").replace("€", "").replace("\"", "");

		if (malus_bonus.equals("150kW(204ch)") || malus_bonus.equals("100kW(136ch)"))
		{
			return;
		}

		if (malus_bonus.length() == 1){
			malus_bonus="0"; 
		} 

		// colonne cout energie
        String cout;
 	    cout = splitted_line[4];
		String[] cout_splitted = cout.split(" ");
		if(cout_splitted.length == 2){  
			cout = cout_splitted[0];
		} else if(cout_splitted.length == 3){ 
			cout= cout_splitted[0] + cout_splitted[1];
		}

		// colonne Rejet CO2
		String rejet = splitted_line[3];

		int malus_bonusInt = Integer.parseInt(malus_bonus);
		int rejetInt = Integer.parseInt(rejet);
		int coutInt = Integer.parseInt(cout);
	
		// on crée le couple key value avec la marque comme key
		String new_value = String.valueOf(malus_bonusInt) + "|" +  String.valueOf(rejetInt) + "|" + String.valueOf(coutInt);
		
        context.write(new Text(marque), new Text(new_value));
	}
}