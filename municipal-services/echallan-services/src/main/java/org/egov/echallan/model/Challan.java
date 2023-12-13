/*
 * eChallan System
 * ### API Specs For eChallan System ### 1. Generate the new challan. 2. Update the details of existing challan 3. Search the existing challan 4. Generate the demand and bill for the challan amount so that collection can be done in online and offline mode. 
 *
 * OpenAPI spec version: 1.0.0
 * Contact: contact@egovernments.org
 *
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen.git
 * Do not edit the class manually.
 */

package org.egov.echallan.model;

import java.math.BigDecimal;
import java.util.List;

import javax.validation.Valid;

import org.egov.echallan.web.models.calculation.Calculation;
import org.hibernate.validator.constraints.SafeHtml;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonValue;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Capture the challan details 
 */
@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.JavaClientCodegen", date = "2020-08-10T16:46:24.044+05:30[Asia/Calcutta]")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Challan {

  @JsonProperty("citizen")
  private UserInfo citizen ;

  @JsonProperty("id")
  @SafeHtml
  private String id ;

  @JsonProperty("tenantId")
  @SafeHtml
  private String tenantId ;

  @JsonProperty("businessService")
  @SafeHtml
  private String businessService ;

  @JsonProperty("challanNo")
  @SafeHtml
  private String challanNo ;

  @JsonProperty("referenceId")
  @SafeHtml
  private String referenceId ;

  @JsonProperty("description")
  @SafeHtml
  private String description ;

  @JsonProperty("accountId")
  @SafeHtml
  private String accountId ;

  @JsonProperty("additionalDetail")

  private Object additionalDetail ;

  @JsonProperty("source")
  @SafeHtml
  private String source ;
  
  @JsonProperty("taxPeriodFrom")
  private Long taxPeriodFrom ;

  @JsonProperty("taxPeriodTo")
  private Long taxPeriodTo ;

  @JsonProperty("calculation")
  private Calculation calculation;
  
  @JsonProperty("amount")
  private List<Amount> amount;

  @JsonProperty("address")

  private Address address ;
  
  @JsonProperty("filestoreid")
  @SafeHtml
  private String filestoreid ;

  @JsonProperty("auditDetails")

  private AuditDetails auditDetails;
  public Challan citizen(UserInfo citizen) {
    this.citizen = citizen;
    return this;
  }

  public enum StatusEnum {
	  ACTIVE("ACTIVE"),

	  CANCELLED("CANCELLED"),

	  PAID("PAID");

      private String value;

      StatusEnum(String value) {
          this.value = value;
      }

      @Override
      @JsonValue
      public String toString() {
          return String.valueOf(value);
      }

      @JsonCreator
      public static StatusEnum fromValue(String text) {
          for (StatusEnum b : StatusEnum.values()) {
              if (String.valueOf(b.value).equals(text)) {
                  return b;
              }
          }
          return null;
      }
  }

  @JsonProperty("applicationStatus")
  private StatusEnum applicationStatus;
  
	// Expense fields
	@JsonProperty("vendor")
	@SafeHtml
	private String vendor ;

	@JsonProperty("typeOfExpense")
	@SafeHtml
	private String typeOfExpense ;

	@JsonProperty("billDate")
	private Long billDate ;

	@JsonProperty("billIssuedDate")
	private Long billIssuedDate;

	@JsonProperty("paidDate")
	private Long paidDate ;

    @JsonProperty("NewpaidDate")
    private Long NewpaidDate ;

	@JsonProperty("isBillPaid")
	private Boolean isBillPaid;
	
	@JsonProperty("vendorName")
	private String vendorName;
	
	@JsonProperty("totalAmount")
	private BigDecimal totalAmount;
}
