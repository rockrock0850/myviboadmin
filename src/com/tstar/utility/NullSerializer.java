package com.tstar.utility;

import java.io.IOException;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

/**
 * 客製化ObjectMapper類別的Serializer過濾器功能，使過濾器將null value轉成空字串("")
 * @author Adam
 *
 */
public class NullSerializer extends JsonSerializer<Object> {

	@Override
	public void serialize(Object arg0, JsonGenerator arg1, SerializerProvider arg2)
			throws IOException, JsonProcessingException {
		arg1.writeString("");
	}
}
