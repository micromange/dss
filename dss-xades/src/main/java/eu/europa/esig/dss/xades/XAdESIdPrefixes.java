/**
 * DSS - Digital Signature Services
 * Copyright (C) 2015 European Commission, provided under the CEF programme
 *
 * This file is part of the "DSS - Digital Signature Services" project.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */
package eu.europa.esig.dss.xades;

import java.util.HashSet;
import java.util.Set;
import java.util.regex.Pattern;

public class XAdESIdPrefixes {
	private static final String ID_PREFIX = "id-";
	private static final String TIMESTAMP_PREFIX = "ts-";
	private static final String ENCAPSULATED_TIMESTAMP_PREFIX = "ets-";
	private static final String KEYINFO_PREFIX = "keyInfo-";
	private static final String VALUE_PREFIX = "value-";
	private static final String XADES_PREFIX = "xades-";

	/** Xml Id prefix */
	private final String id;
	/** Id-prefix for TimeStamp element */
	private final String timestamp;
	/** Id-prefix for EncapsulatedTimeStamp element */
	private final String encapsulatedTimestamp;
	/** Id-prefix for KeyInfo element */
	private final String keyInfo;
	/** Id-prefix for SignatureValue element */
	private final String value;
	/** Id-prefix for Signature element */
	private final String xades;

	public String getId() {
		return id;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public String getEncapsulatedTimestamp() {
		return encapsulatedTimestamp;
	}

	public String getKeyInfo() {
		return keyInfo;
	}

	public String getValue() {
		return value;
	}

	public String getXades() {
		return xades;
	}

	public static XAdESIdPrefixes.XAdESIdBuilder newBuilder() {
		return new XAdESIdPrefixes.XAdESIdBuilder();
	}

	private XAdESIdPrefixes(XAdESIdBuilder builder) {
		this.id = builder.id;
		this.timestamp = builder.timestamp;
		this.encapsulatedTimestamp = builder.encapsulatedTimestamp;
		this.keyInfo = builder.keyInfo;
		this.value = builder.value;
		this.xades = builder.xades;
		validate();
	}

	private void validate() {
		Set<String> prefixesToValidate = new HashSet<>();
		prefixesToValidate.add(id);
		prefixesToValidate.add(timestamp);
		prefixesToValidate.add(encapsulatedTimestamp);
		prefixesToValidate.add(keyInfo);
		prefixesToValidate.add(value);
		prefixesToValidate.add(xades);

		if (prefixesToValidate.size() != 6) {
			throw new IllegalArgumentException("All prefixes needs to be unique!");
		}
		// Regular expression pattern to match illegal XML characters
		Pattern illegalXmlCharactersPattern = Pattern.compile("[&<>\"']");

		for (String prefix : prefixesToValidate) {
			if (illegalXmlCharactersPattern.matcher(prefix).find()) {
				throw new IllegalArgumentException("Id contains invalid XML character: " + prefix);
			}
		}
	}

	public static class XAdESIdBuilder {
		private String id = ID_PREFIX;
		private String timestamp = TIMESTAMP_PREFIX;
		private String encapsulatedTimestamp = ENCAPSULATED_TIMESTAMP_PREFIX;
		private String keyInfo = KEYINFO_PREFIX;
		private String value = VALUE_PREFIX;
		private String xades = XADES_PREFIX;

		public XAdESIdBuilder id(String id) {
			this.id = id;
			return this;
		}

		public XAdESIdBuilder timestamp(String timestamp) {
			this.timestamp = timestamp;
			return this;
		}

		public XAdESIdBuilder encapsulatedTimestamp(String encapsulatedTimestamp) {
			this.encapsulatedTimestamp = encapsulatedTimestamp;
			return this;
		}

		public XAdESIdBuilder keyInfo(String keyInfo) {
			this.keyInfo = keyInfo;
			return this;
		}

		public XAdESIdBuilder value(String value) {
			this.value = value;
			return this;
		}

		public XAdESIdBuilder xades(String xades) {
			this.xades = xades;
			return this;
		}

		public XAdESIdPrefixes build() {
			return new XAdESIdPrefixes(this);
		}
	}
}