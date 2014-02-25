module MessageColumns
  #https://svn.spinvox.lan/viewcvs/svn/scoring.automation/headers/asr.eval.header?view=markup
  
  COLS = {
   'Message_id' => :message_id,
   'Data_Centre' => :data_centre,
   'Language' => :language,
   'date_time' => :date_time,
   'Carrier' => :carrier,
   'Customer' => :customer,
  'Scoring_agent_id' => :scorer_id,
  'Scoring_agent_QCHouse' => :scorer_qch,
  'Converting_agent_name' => :agent_id,
  'Converting_Agent_QCHouse' => :agent_qch,
  'Appa_Conf' => :appa,                                                  
  'UPS' => :ups,
  'Final_status' => :final_status,
'Correct_status' => :correct_status,
'class_of_service_name' => :service_type,
'scrid' => :scrid,
'First_Scoring_Comment' => :comment,
'Conversion.ORIGINAL' => :conversion,
'Correct_Text.CLEAN' => :correct_text,
'error_code' => :error_code,
'error_count' => :error_count,
'patch_count_ref' => :patch_count_ref,
'Critical_ref' => :critical_ref,
'HighImpact_ref' => :high_impact_ref,
'Major_ref' => :major_ref,
'MediumImpact_ref' => :medium_impact_ref,
'Minor_ref' => :minor_ref,
'Notes_ref' => :notes_ref,
'Conversion.CLEAN' => :conversion_clean,
"minimum_edit_distance.SCO-CON" => :minimum_edit_distance_sco_con,
"message_length.SCO-CON" => :message_length_sco_con,
"DEL.SCO-CON" => :del_sco_con,
"INS.SCO-CON" => :ins_sco_con,
"SUB.SCO-CON" => :sub_sco_con,
"COR.SCO-CON" => :cor_sco_con,
"Language.ASR" => :language_asr,
"Profile.ASR" => :profile_asr,
"gender.ASR" => :gender_asr,
"mode.ASR" => :mode_asr,
"speech_frames" => :speech_frames,
"estimated_hitrate" => :estimated_hitrate,
"1best.ASR" => :one_best_asr,
"confidences" => :confidences,
"minimum_edit_distance.SCO-ASR" => :minimum_edit_distance_sco_asr,
"message_length.SCO-ASR" => :message_length_sco_asr,
"DEL.SCO-ASR" => :del_sco_asr,
"INS.SCO-ASR" => :ins_sco_asr,
"SUB.SCO-ASR" => :sub_sco_asr,
"COR.SCO-ASR" => :cor_sco_asr,
"minimum_edit_distance.CON-ASR" => :minimum_edit_distance_con_asr,
"message_length.CON-ASR" => :message_length_con_asr,
"DEL.CON-ASR" => :del_con_asr,
"INS.CON-ASR" => :ins_con_asr,
"SUB.CON-ASR" => :sub_con_asr,
"COR.CON-ASR" => :cor_con_asr
  }
  
  COLS_RI = {}
  COLS.each_pair { |k,v| COLS_RI[v] = k } 
  
  module MessageColumnsClassMethods
    
    def known_columns
      COLS_RI.keys
    end
    
    def column_map(header) 
      columns = header.split /\t/;
      unkown_columns = columns - known_columns
      raise ArgumentError, unkown_columns.inspect unless unkown_columns.empty?
      columns.map { |col| COLS[col] }
    end
  end
  
  
  def self.included(base)
    base.extend MessageColumnsClassMethods
    base.class_eval do 
      attr_accessor *(known_columns - column_names.map(&:to_sym))
    end
  end

end


