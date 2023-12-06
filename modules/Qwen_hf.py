from pathlib import Path

from transformers import AutoModelForCausalLM, AutoTokenizer, StoppingCriteriaList
from transformers.generation import GenerationConfig

from modules import shared
from modules.logging_colors import logger
from modules.callbacks import (
    Iteratorize,
    Stream,
    _StopEverythingStoppingCriteria
)

class Qwen_HF:

    def __init__(self):
        pass

    @classmethod
    def from_pretrained(self, path_to_model):
        
        assert shared.args.trust_remote_code == True, "Qwen needs --trust-remote-code in cmd args"

        combined_path_to_model = Path(f'{shared.args.model_dir}') / Path(path_to_model)
        
        is_quantized = "int4" in path_to_model.lower() or "int8" in path_to_model.lower()
        if shared.args.auto_devices == False and is_quantized:
            logger.warning('You are running Quantized Qwen without --auto-devices. If Optium warns you about disable_exllama kernel, you can ignore it. Instead, try running with --auto-devices')
        
        tokenizer = AutoTokenizer.from_pretrained(
            combined_path_to_model,
            trust_remote_code=True,
            use_fast=not shared.args.no_use_fast
            )
        # Load the model using huggingface loader, basically any settings to HF Transformer applys to Qwen?
        from modules.models import huggingface_loader
        model = huggingface_loader(path_to_model)

        result = self()
        result.model = model
        result.tokenizer = tokenizer
        return result

    def generate_with_streaming(self, prompt, state):
        # TODO actually apply sampler settings to Qwen's generation
        # generation_config = GenerationConfig(**state)
        generation_config = self.model.generation_config

        if state['auto_max_new_tokens']:
            generation_config.max_new_tokens = None
        else:
            generation_config.max_new_tokens = state['max_new_tokens']
            
        stopping_criteria = StoppingCriteriaList()
        stopping_criteria.append(_StopEverythingStoppingCriteria())
        
        # Use Qwen is chat stream wrapper instead of manually calling self.model.generation
        return self.model.chat_stream(
            tokenizer=self.tokenizer, 
            query=prompt, 
            generation_config=generation_config,
            stopping_criteria=stopping_criteria,
            history=None)

    def generate(self, prompt, state):
        output =''
        for output in self.generate_with_streaming(prompt, state):
            pass

        return output
