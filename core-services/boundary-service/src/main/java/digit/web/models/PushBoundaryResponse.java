package digit.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.Valid;
import lombok.Builder;
import org.egov.common.contract.response.ResponseInfo;

@Builder
public class PushBoundaryResponse
{
    @JsonProperty("ResponseInfo")
    @Valid
    private ResponseInfo responseInfo = null;

    private String message;
}
